//
//  MyLevelProgressResponseDTO.swift
//  StreetDrop
//
//  Created by thoonk on 2024/04/11.
//

import Foundation

struct MyLevelProgressResponseDTO: Decodable {
    let isShow: Bool
    let remainCount: Int
    let dropCount: Int
    let levelUpCount: Int
    let tip: String
}

extension MyLevelProgressResponseDTO {
    func toEntity() -> MyLevelProgress {
        return MyLevelProgress(
            isShow: isShow,
            remainCount: remainCount,
            dropCount: dropCount,
            levelUpCount: levelUpCount,
            tip: tip
        )
    }
}
