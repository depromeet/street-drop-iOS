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
    }

    struct Music {
        let title: String
        let artist: String
        let albumName: String
        let albumCover: String
        let genre: [String]
    }

    let location: Location
    let music: Music
    
    private let locationManager: LocationManager

    init(
        location: Location,
        music: Music,
        locationManager: LocationManager = DefaultLocationManager(),
    ) {
        self.location = location
        self.music = music
        self.locationManager = locationManager
    }
}
