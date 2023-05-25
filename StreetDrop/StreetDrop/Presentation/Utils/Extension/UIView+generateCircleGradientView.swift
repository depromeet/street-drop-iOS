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
        viewBackgroundColor: UIColor
    ){
        let axialGradient = CAGradientLayer()
        axialGradient.type = .axial
        axialGradient.colors = colors
        axialGradient.locations = gradientLocations
        axialGradient.startPoint = CGPoint(x: 0.5, y: 0)
        axialGradient.endPoint = CGPoint(x: 0.5, y: 1)
        axialGradient.frame = self.bounds

        self.backgroundColor = viewBackgroundColor
        self.layer.addSublayer(axialGradient)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }
}
