//
//  UIColor+.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/14.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let aaa, rrr, ggg, bbb: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aaa, rrr, ggg, bbb) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aaa, rrr, ggg, bbb) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aaa, rrr, ggg, bbb) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aaa, rrr, ggg, bbb) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(rrr) / 255, green: CGFloat(ggg) / 255, blue: CGFloat(bbb) / 255, alpha: CGFloat(aaa) / 255)
    }

    func hexString(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString)
    }
}

/*
 Hex Color Set
 */
public extension UIColor {

    static var primary100: UIColor {
        UIColor(hexString: "#E5FEFF")
    }

    static var primary200: UIColor {
        UIColor(hexString: "#C4FDFF")
    }

    static var primary300: UIColor {
        UIColor(hexString: "#A3FAFF")
    }

    static var primary400: UIColor {
        UIColor(hexString: "#88F6FC")
    }

    static var primary500: UIColor {
        UIColor(hexString: "#68EFF7")
    }

    static var primary500Alpha75: UIColor {
        UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.75)
    }

    static var primary500_50: UIColor {
        UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.5)
    }

    static var primary500_25: UIColor {
        UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.25)
    }

    static var primary500_16: UIColor {
        UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.16)
    }

    static var primary500_10: UIColor {
        UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.10)
    }

    static var primary600: UIColor {
        UIColor(hexString: "#43E6F0")
    }

    static var primary700: UIColor {
        UIColor(hexString: "#20DAE5")
    }

    static var primary800: UIColor {
        UIColor(hexString: "#09C2D6")
    }

    static var primary900: UIColor {
        UIColor(hexString: "#02B1CC")
    }

    static var primaryGradation_1: UIColor {
        UIColor(hexString: "#E5FEFF")
    }

    static var primaryGradation_2: UIColor {
        UIColor(hexString: "#9EF9FF")
    }

    static var primaryGradation_3: UIColor {
        UIColor(hexString: "#68EFF7")
    }

    static var pointGradation_1: UIColor {
        UIColor(hexString: "#98F9FF")
    }

    static var pointGradation_2: UIColor {
        UIColor(hexString: "#98FFDA")
    }

    static var gray50: UIColor {
        UIColor(hexString: "#E6EDF8")
    }

    static var gray100: UIColor {
        UIColor(hexString: "#D7E1EE")
    }

    static var gray150: UIColor {
        UIColor(hexString: "#C8D3E3")
    }

    static var gray200: UIColor {
        UIColor(hexString: "#A5B2C5")
    }

    static var gray300: UIColor {
        UIColor(hexString: "#7B8696")
    }

    static var gray400: UIColor {
        UIColor(hexString: "#5D6470")
    }

    static var gray500: UIColor {
        UIColor(hexString: "#3D424B")
    }

    static var gray600: UIColor {
        UIColor(hexString: "#2A2F38")
    }

    static var gray700: UIColor {
        UIColor(hexString: "#20242C")
    }
    static var gray800: UIColor {
        UIColor(hexString: "#17191F")
    }

    static var gray900: UIColor {
        UIColor(hexString: "#0F1114")
    }

    static var darkGradient_1: UIColor {
        UIColor(hexString: "#0F1114")
    }

    static var darkGradient_2: UIColor {
        UIColor(hexString: "#17191F")
    }
}