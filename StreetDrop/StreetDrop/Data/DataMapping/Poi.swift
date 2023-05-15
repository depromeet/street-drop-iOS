//
//  POIResponse.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/13.
//

import Foundation

struct Poi: Codable {
    let allPOI: [Poi]

    struct Poi: Codable {
        let itemID: Int
        let albumCover: URL
        let latitude: Double
        let longitude: Double

        private enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case albumCover, latitude, longitude
        }
    }

    private enum CodingKeys: String, CodingKey {
        case allPOI = "poi"
    }
}
