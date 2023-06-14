//
//  MusicWithinAreaEntity.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/11.
//

import Foundation

struct MusicWithinAreaEntity {
    let id: Int
    let userName: String
    let userProfileImageURL: String
    let musicApp: String
    let address: String
    let musicTitle: String
    let artist: String
    let albumImageURL: String
    let genre: [String]
    let content: String
    let createdAt: String
    var isLiked: Bool
    var likeCount: Int
}

typealias Musics = [MusicWithinAreaEntity]
