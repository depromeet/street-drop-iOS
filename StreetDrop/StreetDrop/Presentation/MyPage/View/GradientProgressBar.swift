//
//  GradientProgressBar.swift
//  StreetDrop
//
//  Created by thoonk on 2024/03/25.
//

import UIKit

final class GradientProgressBar: UIView {

    private var progress: CGFloat = 0.0
    
    var gradientColors: [UIColor] = [] {
        didSet {
            gradientLayer.colors = gradientColors.map { $0.cgColor }
        }
    }
    
    var cornerRadius: CGFloat = 0 {
         didSet {
             self.layer.cornerRadius = cornerRadius
             self.clipsToBounds = true
         }
    }
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return layer
    }()
    
    private let maskLayer: CALayer = {
        let mask = CALayer()
        mask.backgroundColor = UIColor.white.cgColor
        return mask
    }()

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
        makeMaskLayerAnimation(animated: false)
    }
    
    func setProgress(_ newProgress: CGFloat, animated: Bool = false) {
        progress = min(max(newProgress, 0.0), 1.0)
        makeMaskLayerAnimation(animated: animated)
    }
}

// MARK: - Private Methods

private extension GradientProgressBar {
    func setup() {
        backgroundColor = .gray600
        setupLayers()
    }
    
    func setupLayers() {
        gradientLayer.mask = maskLayer
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func makeMaskLayerAnimation(animated: Bool) {
        var maskLayerFrame = bounds
        maskLayerFrame.size.width *= progress
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            self?.maskLayer.frame = maskLayerFrame
        }
    }
}
