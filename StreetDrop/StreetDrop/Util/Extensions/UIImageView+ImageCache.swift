//
//  UIImageView+ImageCache.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift

extension UIImageView {
    func setImage(
        with url: String,
        isUsingDiskCache: Bool = false,
        isImageFromAppleServer: Bool,
        disposeBag: DisposeBag
    ) {
        ImageCacheService.shared.setImage(
            url,
            isUsingDiskCache: isUsingDiskCache,
            isImageFromAppleServer: isImageFromAppleServer
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] image in
            self?.image = UIImage(data: image)
        })
        .disposed(by: disposeBag)
    }
}
