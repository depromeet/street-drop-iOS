//
//  DropMusicRequestDTO.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/15.
//

import Foundation

struct DropMusicRequestDTO: Encodable {
    let location: Location
    let music: Music
    let content: String
    
    struct Location: Encodable {
        let latitude: Double
        let longitude: Double
        let address: String
    }
    
    struct Music: Encodable {
        let title: String
        let artist: String
        let albumName: String
        let albumImage: String
        let genre: [String]
    }
}
