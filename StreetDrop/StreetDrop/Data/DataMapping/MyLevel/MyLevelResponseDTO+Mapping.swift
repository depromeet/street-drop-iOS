//
//  MyLevelResponseDTO+Mapping.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

struct MyLevelResponseDTO: Decodable {
    let userID: Int
    let nickname, levelName: String
    let levelImage: String
    let levelDescription: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, levelName, levelImage, levelDescription
    }
}

extension MyLevelResponseDTO {
    func toEntity() -> MyLevel {
        return .init(
            nickName: nickname,
            levelName: levelName,
            levelImageURL: levelImage,
            levelDescription: levelDescription
        )
    }
}
