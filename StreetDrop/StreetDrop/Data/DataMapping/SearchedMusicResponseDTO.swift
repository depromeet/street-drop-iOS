//
//  searchedMusicResponseDTO.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/14.
//

import Foundation

struct SearchedMusicResponseDTO: Decodable {
    let list: [Music]

    struct Music: Decodable {
        let albumName: String
        let artistName: String
        let songName: String
        let durationTime: String
        let albumImage: URL
        let albumThumbnailImage: URL

        private enum CodingKeys: String, CodingKey {
            case albumName, artistName, songName, durationTime
            case albumImage = "albumImg"
            case albumThumbnailImage = "albumThumbnailImg"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}