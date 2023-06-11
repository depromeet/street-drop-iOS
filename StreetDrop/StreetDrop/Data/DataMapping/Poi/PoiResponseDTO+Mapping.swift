//
//  PoiResponseDTO.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/17.
//

import Foundation

struct PoiResponseDTO: Decodable {
    let poi: [Poi]

    struct Poi: Decodable {
        let itemID: Int
        let albumCover: URL
        let latitude: Double
        let longitude: Double

        private enum CodingKeys: String, CodingKey {
            case itemID = "itemId"
            case albumCover, latitude, longitude
        }
    }
}

extension PoiResponseDTO {
    func toEntity() -> Pois {
        return .init(
            poi.map {
                .init(id: $0.itemID,
                      imageURL: $0.albumCover,
                      lat: $0.latitude,
                      lon: $0.longitude)
            }
        )
    }
}
