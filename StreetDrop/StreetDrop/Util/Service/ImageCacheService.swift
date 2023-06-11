//
//  ImageCacheService.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import UIKit

final class ImageCacheService {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
