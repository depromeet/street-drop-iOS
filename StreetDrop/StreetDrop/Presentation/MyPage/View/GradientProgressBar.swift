//
//  GradientProgressBar.swift
//  StreetDrop
//
//  Created by thoonk on 2024/03/25.
//

import UIKit

final class GradientProgressBar: UIView {
    
    var gradientColors: [UIColor] = [
        .pointGradient_1,
        .pointGradient_2,
        .pointGradient_3
    ] {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            updateMaskLayer()
        }
    }
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.anchorPoint = .zero
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        
        return layer
    }()
    
    let maskLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray600.cgColor
        
        return layer
    }()
        
    var cornerRadius: CGFloat = 0 {
         didSet {
             self.layer.cornerRadius = cornerRadius
             self.clipsToBounds = true
         }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateMaskLayer()
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        if animated {
            animateMaskLayer()
        }
        
        self.progress = progress
    }
}

// MARK: - Private Methods

private extension GradientProgressBar {
    func setup() {
        layer.addSublayer(gradientLayer)
        gradientLayer.colors = gradientColors
        gradientLayer.mask = maskLayer
    }
    
    func animateMaskLayer() {
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = maskLayer.bounds.width
        animation.toValue = bounds.width * progress
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayer.add(animation, forKey: "bounds.size.width")
    }
    
    func updateMaskLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = CGRect(x: 0, y: 0, width: bounds.width * progress, height: bounds.height)
        CATransaction.commit()
    }
}
