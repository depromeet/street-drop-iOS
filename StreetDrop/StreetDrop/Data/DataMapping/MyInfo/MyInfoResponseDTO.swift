//
//  MyInfoResponseDTO.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

struct MyInfoResponseDTO: Decodable {
    let userID: Int
    let nickname: String
    let profileImage: String
    let musicApp: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, profileImage, musicApp
    }

    func toEntity() -> MyInfo {
        return MyInfo(
            userID: userID,
            nickname: nickname,
            profileImage: profileImage,
            musicApp: musicApp
        )
    }
}
