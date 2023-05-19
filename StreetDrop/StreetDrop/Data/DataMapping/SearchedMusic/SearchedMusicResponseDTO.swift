//
//  searchedMusicResponseDTO.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/14.
//

import Foundation

struct SearchedMusicResponseDTO: Decodable {
    let musicList: [Music]

    struct Music: Decodable {
        let albumName: String
        let artistName: String
        let songName: String
        let durationTime: String
        let albumImage: String
        let albumThumbnailImage: String
        let genre: [String]
    }

    private enum CodingKeys: String, CodingKey {
        case musicList = "data"
    }
}
