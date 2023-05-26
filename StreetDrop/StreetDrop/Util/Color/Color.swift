//
//  Color.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import UIKit

extension UIColor {
    class var primaryBackground: UIColor {
        return UIColor(named: "NavyBackground") ?? .black
    } // 옵셔널에 RGB로 담아두기

    class var secondaryNavy: UIColor {
        return UIColor(named: "SecondaryNavy") ?? .black
    }

    class var primaryNavy: UIColor {
        return UIColor(named: "PrimaryNavy") ?? .black
    }

    class var primaryNavyGradient: UIColor {
        return UIColor(named: "PrimaryNavyGradient") ?? UIColor.systemBlue
    }
}
