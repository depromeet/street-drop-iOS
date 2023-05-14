//
//  POIResponse.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/13.
//

import Foundation

struct PoiDTO: Codable {
    let allPoi: [Poi]

    struct Poi: Codable {
        let itemID: Int
        let albumCover: URL
        let latitude: Double
        let longitude: Double

        private enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case albumCover, latitude, longitude
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            itemID = try container.decode(Int.self, forKey: .itemID)
            albumCover = try container.decode(URL.self, forKey: .albumCover)
            latitude = try container.decode(Double.self, forKey: .latitude)
            longitude = try container.decode(Double.self, forKey: .longitude)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case allPoi = "poi"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allPoi = try container.decode([Poi].self, forKey: .allPoi)
    }
}
