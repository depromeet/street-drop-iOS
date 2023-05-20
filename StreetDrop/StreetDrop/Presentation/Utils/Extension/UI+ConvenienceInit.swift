//
//  UILabel+ConvenienceInit.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/18.
//

import UIKit


extension UILabel {
    convenience init(
        text: String = "",
        textColor: UIColor = .white,
        textAlignment: NSTextAlignment = .natural,
        font: UIFont.TextStyle = .body,
        numberOfLines: Int = 1,
        cornerRadius: CGFloat = 0
    )
    {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = .preferredFont(forTextStyle: font)
        self.numberOfLines = numberOfLines
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImageView {
    convenience init(cornerRadius: CGFloat = 0) {
        self.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false

        if let loadingImage = UIImage(systemName: "slowmo") {
            self.image = loadingImage
        }
    }
}

extension UITextView {
    convenience init(
        text: String = "",
        textColor: UIColor = .white,
        font: UIFont.TextStyle = .body,
        backgroundColor: UIColor = .black,
        cornerRadius: CGFloat = 0,
        inset: CGFloat = 10
    ){
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = .preferredFont(forTextStyle: font)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.textContainerInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        self.showsVerticalScrollIndicator = false
    }
}

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0
    ){
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
}