//
//  UIImage+Resizing.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import UIKit

extension UIImage {
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
