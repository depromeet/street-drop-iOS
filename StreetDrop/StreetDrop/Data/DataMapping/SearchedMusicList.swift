//
//  SearchedMusicList.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/14.
//

import Foundation

struct SearchedMusicList: Codable {
    let list: [Music]

    struct Music: Codable {
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

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.albumName = try container.decode(String.self, forKey: .albumName)
            self.artistName = try container.decode(String.self, forKey: .artistName)
            self.songName = try container.decode(String.self, forKey: .songName)
            self.durationTime = try container.decode(String.self, forKey: .durationTime)
            self.albumImage = try container.decode(URL.self, forKey: .albumImage)
            self.albumThumbnailImage = try container.decode(URL.self, forKey: .albumThumbnailImage)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case list = "data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decode([SearchedMusicList.Music].self, forKey: .list)
    }
}
