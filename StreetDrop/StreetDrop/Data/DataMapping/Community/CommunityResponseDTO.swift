//
//  CommunityResponseDTO.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/16.
//

import Foundation

// MARK: - Data Transfer Object

struct CommunityResponseDTO: Decodable {
    let user: UserDTO
    let location: LocationDTO
    let music: MusicDTO
    let content, createdAt: String
}

extension CommunityResponseDTO {
    struct LocationDTO: Decodable {
        let address: String
    }

    struct MusicDTO: Decodable {
        let title, artist, albumCover: String
    }

    struct UserDTO: Decodable {
        let nickname, profileImg, musicApp: String
    }
}
