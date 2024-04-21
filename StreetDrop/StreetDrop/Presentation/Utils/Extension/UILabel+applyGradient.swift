//
//  UILabel+applyGradient.swift
//  StreetDrop
//
//  Created by thoonk on 4/21/24.
//

import UIKit

extension UILabel {
    func applyGradientWith(colors: [UIColor], locations: [Double]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        
        let maskLayer = CALayer()
        maskLayer.contents = image.cgImage
        maskLayer.frame = bounds
        gradientLayer.mask = maskLayer
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
