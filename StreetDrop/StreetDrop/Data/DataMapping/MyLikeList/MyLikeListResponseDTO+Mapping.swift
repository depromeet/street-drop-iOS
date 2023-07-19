//
//  MyLikeList.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

struct MyLikeListResponseDTO: Decodable {
    let data: [Datum]
    let meta: Meta
    
    struct Datum: Decodable {
        let date: String
        let value: [Value]
    }
    
    struct Value: Decodable {
        let itemID: Int
        let user: User
        let location: Location
        let music: Music
        let content, createdAt: String
        let itemLikeCount: Int
        
        enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case location, user, music, content, createdAt, itemLikeCount
        }
    }
    
    struct Location: Decodable {
        let address: String
    }
    
    struct Music: Decodable {
        let title, artist, albumImage: String
    }
    
    struct User: Decodable {
        let userID: Int
        let nickname: String
        let profileImage: String
        let musicApp: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case nickname, profileImage, musicApp
        }
    }
    
    struct Meta: Decodable {
        let totalCount, nextCursor: Int
    }
}

extension MyLikeListResponseDTO {
    func toEntity() -> TotalMyMusics {
        return .init(
            musics: data.map { datum in
                .init(
                    date: datum.date,
                    musics: datum.value.map { value in
                        .init(
                            albumImageURL: value.music.albumImage,
                            singer: value.music.artist,
                            song: value.music.title,
                            comment: value.content,
                            location: value.location.address,
                            likeCount: value.itemLikeCount
                        )
                    }
                )
            },
            totalCount: meta.totalCount
        )
    }
}
