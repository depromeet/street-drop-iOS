//
//  UIImageView+makeCircleShape.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import UIKit

extension UIImageView {
    func makeCircleShape() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
}
