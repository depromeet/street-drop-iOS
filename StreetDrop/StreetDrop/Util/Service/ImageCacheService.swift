//
//  ImageCacheService.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/12.
//

import UIKit

import RxSwift

struct ImageCache {
    private(set) var maximumDiskSize: Int = 0
    private(set) var currentDiskSize: Int = 0
    private var cache = NSCache<NSString, CacheableImage>()
    
    mutating func configureCachePolicy(with maximumMemoryBytes: Int, with maximumDiskBytes: Int) {
        self.cache.totalCostLimit = maximumMemoryBytes
        self.maximumDiskSize = maximumDiskBytes
        self.currentDiskSize = self.countCurrentDiskSize()
    }
    
    mutating func updateCurrentDiskSize(with itemSize: Int) {
        self.currentDiskSize += itemSize
    }
    
    mutating func save(data: CacheableImage, with key: String) {
        let key = NSString(string: key)
        self.cache.setObject(data, forKey: key, cost: data.imageData.count)
    }
    
    func read(with key: String) -> CacheableImage? {
        let key = NSString(string: key)
        return self.cache.object(forKey: key)
    }
    
    private func countCurrentDiskSize() -> Int {
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask)
        guard let path = cacheDirectoryPath.first else { return 0 }
        
        let profileImagePath = path.appendingPathComponent("profileImage")
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: profileImagePath.path) else {
            return 0
        }
        
        var totalSize = 0
        for content in contents {
            let fullContentPath = profileImagePath.appendingPathComponent(content)
            let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fullContentPath.path)
            totalSize += fileAttributes?[FileAttributeKey.size] as? Int ?? 0
        }
        return totalSize
    }
}

final class ImageCacheService {
    static let shared = ImageCacheService()
    private var cache = ImageCache()
    private init () {}
    
    func configureCache(with maximumMemoryBytes: Int, with maximumDiskBytes: Int) {
        self.cache.configureCachePolicy(with: maximumMemoryBytes, with: maximumDiskBytes)
    }
    
    func setImage(_ url: String, isUsingDiskCache: Bool) -> Observable<Data> {
        guard let imageURL = URL(string: url) else {
            return Observable.error(ImageCacheError.invalidURLError)
        }
        
        // 1. Lookup NSCache
        if let image = self.checkMemory(imageURL) {
            return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
                .map({ $0.imageData })
                .catchAndReturn(image.imageData)
        }
        
        // 2. Lookup Disk
        if isUsingDiskCache {
            if let image = self.checkDisk(imageURL) {
                return self.get(imageURL: imageURL, etag: image.cacheInfo.etag)
                    .map({ $0.imageData })
                    .catchAndReturn(image.imageData)
            }
        }
        
        // 3. Network Request
        return self.get(imageURL: imageURL)
            .map({ $0.imageData })
    }
    
    private func get(imageURL: URL, etag: String? = nil) -> Observable<CacheableImage> {
        return Observable<CacheableImage>.create { emitter in
            var request = URLRequest(url: imageURL)
            if let etag = etag {
                request.addValue(etag, forHTTPHeaderField: "If-None-Match")
            }
            let disposable = URLSession.shared.rx.response(request: request).subscribe(
                onNext: { [weak self] (response, data) in
                    switch response.statusCode {
                    case (200...299):
                        let etag = response.allHeaderFields["Etag"] as? String ?? ""
                        let image = CacheableImage(imageData: data, etag: etag)
                        self?.saveIntoCache(imageURL: imageURL, image: image)
                        self?.saveIntoDisk(imageURL: imageURL, image: image)
                        emitter.onNext(image)
                    case 304:
                        emitter.onError(ImageCacheError.imageNotModifiedError)
                    case 402:
                        emitter.onError(ImageCacheError.networkUsageExceedError)
                    default:
                        emitter.onError(ImageCacheError.unknownNetworkError)
                    }
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
            
            return Disposables.create(with: disposable.dispose)
        }
    }
    
    private func checkMemory(_ imageURL: URL) -> CacheableImage? {
        guard let cached = self.cache.read(with: imageURL.path) else { return nil }
        self.updateLastRead(of: imageURL, currentEtag: cached.cacheInfo.etag)
        return cached
    }
    
    private func checkDisk(_ imageURL: URL) -> CacheableImage? {
        guard let filePath = self.createImagePath(with: imageURL) else { return nil }
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let cachedData = UserDefaults.standard.data(forKey: imageURL.path),
                  let cachedInfo = self.decodeCacheData(data: cachedData) else { return nil }
            
            let image = CacheableImage(imageData: imageData, etag: cachedInfo.etag)
            self.saveIntoCache(imageURL: imageURL, image: image)
            self.updateLastRead(of: imageURL, currentEtag: cachedInfo.etag, to: image.cacheInfo.lastRead)
            
            return image
        }
        return nil
    }
    
    private func updateLastRead(of imageURL: URL, currentEtag: String, to date: Date = Date()) {
        let updated = CacheInfo(etag: currentEtag, lastRead: date)
        guard let encoded = encodeCacheData(cacheInfo: updated),
              UserDefaults.standard.object(forKey: imageURL.path) != nil else { return }
        
        UserDefaults.standard.set(encoded, forKey: imageURL.path)
    }
    
    private func saveIntoCache(imageURL: URL, image: CacheableImage) {
        self.cache.save(data: image, with: imageURL.path)
    }
    
    private func saveIntoDisk(imageURL: URL, image: CacheableImage) {
        guard let filePath = self.createImagePath(with: imageURL) else { return }
        
        let cacheInfo = CacheInfo(etag: image.cacheInfo.etag, lastRead: Date())
        let targetByteCount = image.imageData.count
        
        while targetByteCount <= self.cache.maximumDiskSize
                && self.cache.currentDiskSize + targetByteCount > self.cache.maximumDiskSize {
            var removeTarget: (imageURL: String, minTime: Date) = ("", Date())
            UserDefaults.standard.dictionaryRepresentation().forEach({ key, value in
                guard let cacheInfoData = value as? Data,
                      let cacheInfoValue = self.decodeCacheData(data: cacheInfoData) else { return }
                if removeTarget.minTime > cacheInfoValue.lastRead {
                    removeTarget = (key, cacheInfoValue.lastRead)
                }
            })
            self.deleteFromDisk(imageURL: removeTarget.imageURL)
        }
        
        if self.cache.currentDiskSize + targetByteCount <= self.cache.maximumDiskSize {
            guard let encoded = encodeCacheData(cacheInfo: cacheInfo) else { return }
            UserDefaults.standard.set(encoded, forKey: imageURL.path)
            FileManager.default.createFile(atPath: filePath.path, contents: image.imageData, attributes: nil)
            self.cache.updateCurrentDiskSize(with: targetByteCount)
        }
    }
    
    private func deleteFromDisk(imageURL: String) {
        guard let imageURL = URL(string: imageURL),
              let filePath = self.createImagePath(with: imageURL),
              let targetFileAttribute = try? FileManager.default.attributesOfItem(atPath: filePath.path) else { return }
        
        let targetByteCount = targetFileAttribute[FileAttributeKey.size] as? Int ?? 0
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
            UserDefaults.standard.removeObject(forKey: imageURL.path)
            self.cache.updateCurrentDiskSize(with: targetByteCount * -1)
        } catch {
            return
        }
    }
    
    private func decodeCacheData(data: Data) -> CacheInfo? {
        return try? JSONDecoder().decode(CacheInfo.self, from: data)
    }
    
    private func encodeCacheData(cacheInfo: CacheInfo) -> Data? {
        return try? JSONEncoder().encode(cacheInfo)
    }
    
    private func createImagePath(with imageURL: URL) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return nil }
        let profileImageDirPath = path.appendingPathComponent("profileImage")
        let filePath = profileImageDirPath.appendingPathComponent(imageURL.pathComponents.joined(separator: "-"))
        
        if !FileManager.default.fileExists(atPath: profileImageDirPath.path) {
            try? FileManager.default.createDirectory(
                atPath: profileImageDirPath.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return filePath
    }
}

final class CacheableImage {
    let imageData: Data
    let cacheInfo: CacheInfo
    
    init(imageData: Data, etag: String) {
        self.cacheInfo = CacheInfo(etag: etag, lastRead: Date())
        self.imageData = imageData
    }
}

struct CacheInfo: Codable {
    let etag: String
    let lastRead: Date
}
