//
//  RecommendMusic.swift
//  StreetDrop
//
//  Created by Jieun Kim on 2023/10/15.
//

import Foundation

struct RecommendMusic: Decodable {
    let description: [RecommendMusicData]
    let terms: [RecommendMusicData]
}

struct RecommendMusicData: Decodable {
    let text: String
    let color: String
}
