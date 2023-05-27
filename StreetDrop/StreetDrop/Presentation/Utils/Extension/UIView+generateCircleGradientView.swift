//
//  UIView+generateCircleGradientView.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/20.
//

import UIKit

extension UIView {
    func makeGradientCircleView(
        colors: [Any],
        gradientLocations: [NSNumber],
        viewBackgroundColor: UIColor,
        startPoint: CGPoint,
        endPoint: CGPoint
    ){
        let axialGradient = CAGradientLayer()
        axialGradient.type = .axial
        axialGradient.colors = colors
        axialGradient.locations = gradientLocations
        axialGradient.startPoint = startPoint
        axialGradient.endPoint = endPoint
        axialGradient.frame = self.bounds

        self.backgroundColor = viewBackgroundColor
        self.layer.addSublayer(axialGradient)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }
}
