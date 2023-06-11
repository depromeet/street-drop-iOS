//
//  PoiEntity.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/10.
//

import Foundation

struct PoiEntity {
    let id: Int
    let imageURL: String
    let lat: Double
    let lon: Double
}

typealias Pois = [PoiEntity]
