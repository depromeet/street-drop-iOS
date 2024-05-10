//
//  GradientLabel.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/3/24.
//

import UIKit

final class GradientLabel: UILabel {
    private let gradientLayer: CAGradientLayer = .init()
    
    init(colors: [UIColor], locations: [Double]) {
        super.init(frame: .zero)
        commonInit(colors: colors, locations: locations)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(colors: [UIColor], locations: [Double]) {
        textColor = .clear
        // 그라데이션 색상 설정
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        // 텍스트를 기반으로 마스크 설정
        let mask = CATextLayer()
        mask.contentsScale = UIScreen.main.scale // 레티나 디스플레이 대응
        mask.font = font
        mask.fontSize = font.pointSize
        mask.frame = bounds
        mask.string = text
        mask.alignmentMode = .center
        mask.foregroundColor = UIColor.black.cgColor // 색상은 중요하지 않음; 마스크로 사용됨
        gradientLayer.mask = mask
    }
}
