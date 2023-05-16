//
//  MusicWithinAreaResponseDTO.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/15.
//

import Foundation

// MARK: - Data Transfer Object

struct MusicWithinAreaResponseDTO: Decodable {
    let items: [ItemDTO]
}

struct ItemDTO: Decodable {
    let itemID: Int
    let music: MusicDTO
    let content: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case music, content
    }
}

struct Music: Decodable {
    let title, artist, albumCover: String
}

