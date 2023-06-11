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
        let location: String
        let music: Music
        let content, createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case user, location, music, content, createdAt
        }
    }
    
    struct Music: Decodable {
        let title, artist: String
        let albumImage: String
        let genre: String
    }
    
    struct User: Decodable {
        let nickname, profileImage, musicApp: String
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
                address: $0.location,
                musicTitle: $0.music.title,
                artist: $0.music.artist,
                albumImageURL: $0.music.albumImage,
                genre: $0.music.genre,
                content: $0.content,
                createdAt: $0.createdAt
            )
        }
    }
}
