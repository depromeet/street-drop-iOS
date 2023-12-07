//
//  SingleMusicResponseDTO.swift
//  StreetDrop
//
//  Created by thoonk on 11/7/23.
//

import Foundation

struct SingleMusicResponseDTO: Decodable {
    let itemID: Int
    let user: User
    let location: Location
    let music: Music
    let content: String
    let createdAt: String
    let isLiked: Bool
    let likeCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case likeCount = "itemLikeCount"
        case user, location, music, content, createdAt, isLiked
    }
    
    struct User: Decodable {
        let userId: Int
        let nickname: String
        let profileImage: String
        let musicApp: String
    }
    
    struct Location: Decodable {
        let address: String
    }
    
    struct Music: Decodable {
        let title: String
        let artist: String
        let albumImage: String
        let genre: [String]
    }
}

extension SingleMusicResponseDTO {
    func toEntity() -> Musics {
        return [
            .init(
                id: itemID,
                userId: user.userId,
                userName: user.nickname,
                userProfileImageURL: user.profileImage,
                musicApp: user.musicApp,
                address: location.address,
                musicTitle: music.title,
                artist: music.artist,
                albumImageURL: music.albumImage,
                genre: music.genre,
                content: content,
                createdAt: createdAt,
                isLiked: isLiked,
                likeCount: likeCount
            )
        ]
    }
}
