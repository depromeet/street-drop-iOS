//
//  RecentMusicQueryDTO.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/24.
//

import Foundation

struct RecentMusicQueryDTO: Codable, Equatable {
    let query: String
}

struct RecentMusicQueryDTOList: Codable {
    var list: [RecentMusicQueryDTO]
}
