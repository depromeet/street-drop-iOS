//
//  MyPageType.swift
//  StreetDrop
//
//  Created by thoonk on 11/8/23.
//

import Foundation

enum MyPageType: Int {
    case dropMusic = 100
    case likeMusic = 101
}

typealias MusicInfo = (type: MyPageType, itemID: Int)
