//
//  UIImage+loadURLImage.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift

extension UIImage {
    static func load(
        with url: String,
        isUsingDiskCache: Bool = false
    ) -> Observable<UIImage?> {
        return ImageCacheService.shared.setImage(url, isUsingDiskCache: isUsingDiskCache)
            .observe(on: MainScheduler.instance)
            .map { return UIImage(data: $0)}
    }
}
