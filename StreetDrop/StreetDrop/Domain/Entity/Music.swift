//
//  Music.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/08.
//

import Foundation

struct Music: Hashable {
    let albumName: String
    let artistName: String
    let songName: String
    let durationTime: String
    let albumImage: String
    let albumThumbnailImage: String
    let genre: [String]
}
