//
//  UIButton+.swift
//  StreetDrop
//
//  Created by thoonk on 2024/03/27.
//

import UIKit

extension UIButton {
    func setInsets(intervalPadding: CGFloat) {
        let halfIntervalPadding = intervalPadding / 2
        self.contentEdgeInsets = .init(top: 0, left: halfIntervalPadding, bottom: 0, right: halfIntervalPadding)
        self.imageEdgeInsets = .init(top: 0, left: -halfIntervalPadding, bottom: 0, right: halfIntervalPadding)
        self.titleEdgeInsets = .init(top: 0, left: halfIntervalPadding, bottom: 0, right: -halfIntervalPadding)
    }
}
