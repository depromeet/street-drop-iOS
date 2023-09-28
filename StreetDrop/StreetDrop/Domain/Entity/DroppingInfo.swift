//
//  MusicForDrop.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/21.
//

import Foundation

struct DroppingInfo {
    struct Location {
        var latitude: Double
        var longitude: Double
        var address: String
    }
    let location: Location
    let music: Music
}
