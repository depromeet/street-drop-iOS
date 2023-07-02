//
//  MusicWithinAreaEntity.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import Foundation

struct MusicWithinAreaEntity {
    let id: Int
    let userId: Int
    let userName: String
    let userProfileImageURL: String
    let musicApp: String
    let address: String
    let musicTitle: String
    let artist: String
    let albumImageURL: String
    let genre: [String]
    var content: String
    let createdAt: String
    var isLiked: Bool
    var likeCount: Int
}

typealias Musics = [MusicWithinAreaEntity]

extension MusicWithinAreaEntity {
    static func generateEmptyData() -> Self {
        let empty: String = ""
        return MusicWithinAreaEntity(
            id: 0,
            userId: 0,
            userName: empty,
            userProfileImageURL: empty,
            musicApp: empty,
            address: empty,
            musicTitle: empty,
            artist: empty,
            albumImageURL: empty,
            genre: [],
            content: empty,
            createdAt: empty,
            isLiked: false,
            likeCount: 0
        )
    }

    func convertToEditInfo() -> EditInfo {
        return EditInfo(
            id: self.id,
            musicTitle: self.musicTitle,
            artist: self.artist,
            albumImageURL: self.albumImageURL,
            content: self.content
        )
    }
}
