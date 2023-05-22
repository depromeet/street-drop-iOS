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
}
