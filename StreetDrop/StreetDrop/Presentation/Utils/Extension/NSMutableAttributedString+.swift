//
//  NSMutableAttributedString+.swift
//  StreetDrop
//
//  Created by thoonk on 2024/03/26.
//

import UIKit

extension NSMutableAttributedString {
    func setColor(_ color: UIColor, of text: String) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        return self
    }
    
    func setFont(_ font: UIFont, text: String) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: text)
        
        addAttributes([
            .font: font
        ], range: range)
        
        return self
    }
}
