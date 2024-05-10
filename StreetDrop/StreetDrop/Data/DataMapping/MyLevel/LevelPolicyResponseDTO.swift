//
//  LevelPolicyResponseDTO.swift
//  StreetDrop
//
//  Created by thoonk on 2024/04/16.
//

import Foundation

struct LevelPolicyResponseDTO: Decodable {
    let data: [LevelPolicyDTO]
    
    struct LevelPolicyDTO: Decodable {
        let level: Int
        let levelName: String
        let levelDescription: String
        let levelImage: String
    }
}

extension LevelPolicyResponseDTO {
    func toEntity() -> [LevelPolicy] {
        return data.map {
            LevelPolicy(
                level: $0.level,
                levelName: $0.levelName,
                levelDescription: $0.levelDescription,
                levelImage: $0.levelImage
            )
        }
    }
}
