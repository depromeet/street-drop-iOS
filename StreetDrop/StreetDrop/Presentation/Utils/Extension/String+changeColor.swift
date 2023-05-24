//
//  String+changeColor.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/23.
//

import UIKit

extension String {
    func changeColorPartially(_ part: String, to color: UIColor) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            .foregroundColor, value: color,
            range: (self as NSString).range(of: part))

        return attributeString
    }
}
