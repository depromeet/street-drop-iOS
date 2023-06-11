//
//  UIImageView+ImageCache.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import UIKit

extension UIImageView {
    func setImage(with url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            if let cachedImage = ImageCacheService.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = cachedImage
                }
                return
            }
            
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheService.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}
