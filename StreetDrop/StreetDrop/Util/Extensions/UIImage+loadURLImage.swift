//
//  UIImage+loadURLImage.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift
import Kingfisher

extension UIImage {
    static func load(
        with urlString: String,
        isUsingDiskCache: Bool = false
    ) -> Single<UIImage> {
        return Single<UIImage>.create { observer in
            guard let url = URL(string: urlString) else {
                observer(.failure(ImageCacheError.invalidURLError))
                return Disposables.create()
            }
            
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print("이미지 가져온 방식: \(value.cacheType == .none ? "네트워크 통신" : "\(value.cacheType) 캐싱")")
                    observer(.success(value.image))
                    
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func load(with urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageCacheError.invalidURLError
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value.image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
