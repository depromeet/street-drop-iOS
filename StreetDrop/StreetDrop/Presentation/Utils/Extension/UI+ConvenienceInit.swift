//
//  UI+ConvenienceInit.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/18.
//

import UIKit

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        inset: CGFloat = 0
    ){
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius

        if inset != 0 {
            self.isLayoutMarginsRelativeArrangement = true
            self.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
}
