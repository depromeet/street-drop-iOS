//
//  PoiResponseDTO.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/17.
//

import Foundation

struct PoiResponseDTO: Decodable {
    let pois: [Poi]

    struct Poi: Decodable {
        let itemID: Int
        let albumThumbnailImage: URL
        let latitude: Double
        let longitude: Double

        private enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case albumThumbnailImage, latitude, longitude
        }
    }

    private enum CodingKeys: String, CodingKey {
        case pois = "poi"
    }
}
