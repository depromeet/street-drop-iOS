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
        let key: String
        let value: Value
    }
    
    struct Value: Decodable {
        let itemID: Int
        let location: Location
        let music: Music
        let content, createdAt: String
        let itemLikeCount: Int

        enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case location, music, content, createdAt, itemLikeCount
        }
    }
    
    struct Location: Decodable {
        let address: String
    }
    
    struct Music: Decodable {
        let title, artist, albumImage: String
    }

    struct Meta: Decodable {
        let totalCount, nextCusor: Int
    }
}


