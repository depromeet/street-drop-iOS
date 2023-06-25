//
//  UILabel+LineHeight.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/22.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat){
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attrString = NSAttributedString(string: self.text ?? "",
                                            attributes: attributes)
        self.attributedText = attrString
    }

    func changeColorPartially(lineHeight: CGFloat, part: String, to color: UIColor) {
        guard let text = self.text else { return }

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(
            .foregroundColor,
            value: color,
            range: (text as NSString).range(of: part)
        )

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4,
        ]

        attrString.addAttributes(attributes, range: (text as NSString).range(of: text))
        self.attributedText = attrString
    }
}
