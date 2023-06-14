//
//  MusicWithinAreaResponseDTO.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/15.
//

import Foundation

struct MusicWithinAreaResponseDTO: Decodable {
    let items: [Item]
    
    struct Item: Decodable {
        let itemID: Int
        let user: User
        let location: Location
        let music: Music
        let content: String?
        let createdAt: String
        let isLiked: Bool
        let likeCount: Int

        enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case likeCount = "itemLikeCount"
            case user, location, music, content, createdAt, isLiked
        }
    }
    
    struct User: Decodable {
        let nickname, profileImage, musicApp: String
    }
    
    struct Location: Decodable {
        let address: String
    }
    
    struct Music: Decodable {
        let title, artist: String
        let albumImage: String
        let genre: [String]
    }
}

extension MusicWithinAreaResponseDTO {
    func toEntity() -> Musics {
        return items.map {
            .init(
                id: $0.itemID,
                userName: $0.user.nickname,
                userProfileImageURL: $0.user.profileImage,
                musicApp: $0.user.musicApp,
                address: $0.location.address,
                musicTitle: $0.music.title,
                artist: $0.music.artist,
                albumImageURL: $0.music.albumImage,
                genre: $0.music.genre,
                content: $0.content ?? "",
                createdAt: $0.createdAt,
                isLiked: $0.isLiked,
                likeCount: $0.likeCount
            )
        }
    }
}
