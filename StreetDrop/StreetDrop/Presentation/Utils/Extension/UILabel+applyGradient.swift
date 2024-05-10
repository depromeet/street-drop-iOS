//
//  UILabel+applyGradient.swift
//  StreetDrop
//
//  Created by thoonk on 4/21/24.
//

import UIKit

extension UILabel {
    @discardableResult
    func applyGradientWith(
        type: CAGradientLayerType? = nil,
        colors: [UIColor],
        locations: [Double],
        startPoint: CGPoint,
        endPoint: CGPoint
    ) -> UILabel {
        let gradientLayer = CAGradientLayer()
        if let type = type { gradientLayer.type = type }
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
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
        
        return self
    }
}
