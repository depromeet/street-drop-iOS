//
//  SearchedMusicResponseDTO+Mapping.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/14.
//

import Foundation

struct SearchedMusicResponseDTO: Decodable {
    let musicList: [MusicDTO]

    struct MusicDTO: Decodable {
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
    
    func toEntity() -> [Music] {
        return self.musicList
            .map {
                Music(albumName: $0.albumName,
                      artistName: $0.artistName,
                      songName: $0.songName,
                      durationTime: $0.durationTime,
                      albumImage: $0.albumImage,
                      albumThumbnailImage: $0.albumThumbnailImage,
                      genre: $0.genre
                )
            }
    }
}
