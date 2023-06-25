//
//  UITextView+setLineSpacing.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/25.
//

import UIKit

extension UITextView {
    func setAttributedString(font: UIFont, lineSpacing: CGFloat, color: UIColor) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing

        let range: NSRange = (text as NSString).range(of: text)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: style, range: range)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)

        self.attributedText = attributedString
    }
}
