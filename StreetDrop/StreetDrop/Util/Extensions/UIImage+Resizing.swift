//
//  UIImage+Resizing.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import UIKit

extension UIImage {
    static func load(with url: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            if let cachedImage = ImageCacheService.shared.object(forKey: cachedKey) {
                completion(cachedImage)
            }
            
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    ImageCacheService.shared.setObject(image, forKey: cachedKey)
                    completion(image)
                }
            }.resume()
        }
    }
    
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    /*
     ex)
     let originalImage = UIImage(named: "example")
     let newSize = CGSize(width: 100, height: 100)
     let resizedImage = originalImage?.resized(to: newSize)
     */
}
