//
//  UIFont+Extension.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/22.
//

import UIKit.UIFont

extension UIFont {
    static func pretendard(
        size: CGFloat,
        weight: Int
    ) -> UIFont {
        return UIFont(
            name: "Pretendard-\(PretendardFontWeight(rawValue: weight)?.style ?? "Regular")",
            size: size
        ) ?? UIFont.boldSystemFont(ofSize: 30)
    }

    static func pretendard(
        size: CGFloat,
        weightName: PretendardFontWeight
    ) -> UIFont {
        return UIFont(
            name: "Pretendard-\(weightName.style)",
            size: size
        ) ?? UIFont.boldSystemFont(ofSize: 30)
    }
}

enum PretendardFontWeight: Int {
    case thin = 100
    case extraLight = 200
    case light = 300
    case regular = 400
    case medium = 500
    case semiBold = 600
    case bold = 700
    case extraBold = 800
    case black = 900
    
    var style: String {
        switch self {
        case .thin:
            return "Thin"
        case .extraLight:
            return "ExtraLight"
        case .light:
            return "Light"
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semiBold:
            return "SemiBold"
        case .bold:
            return "Bold"
        case .extraBold:
            return "ExtraBold"
        case .black:
            return "Black"
        }
    }
}
