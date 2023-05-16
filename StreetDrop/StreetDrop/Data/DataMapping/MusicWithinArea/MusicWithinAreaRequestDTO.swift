//
//  MusicWithinAreaRequestDTO.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/16.
//

import Foundation

// MARK: - Data Transfer Object

struct MusicWithinAreaRequestDTO: Encodable {
    let latitude: Double
    let longitude: Double
    let orderBy: String
}
