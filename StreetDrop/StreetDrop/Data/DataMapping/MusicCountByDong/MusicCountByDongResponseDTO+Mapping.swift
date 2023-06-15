//
//  MusicCountByDongResponseDTO.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/15.
//

import Foundation

struct MusicCountByDongResponseDTO: Decodable {
    let numberOfDroppedMusic: Int
    let villageName: String
}

extension MusicCountByDongResponseDTO {
    func toEntity() -> MusicCountEntity {
        return .init(musicCount: numberOfDroppedMusic, villageName: villageName)
    }
}
