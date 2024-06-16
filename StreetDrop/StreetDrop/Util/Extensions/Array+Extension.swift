//
//  Array+Extension.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
