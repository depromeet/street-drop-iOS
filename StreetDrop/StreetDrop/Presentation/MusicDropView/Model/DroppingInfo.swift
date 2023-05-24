//
//  MusicForDrop.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/21.
//

import Foundation

import RxSwift

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
    private let dropMusicRepository: DropMusicRepository

    init(
        location: Location,
        music: Music,
        locationManager: LocationManager = DefaultLocationManager(),
        dropMusicRepository: DropMusicRepository = DefaultDropMusicRepository()
    ) {
        self.location = location
        self.music = music
        self.locationManager = locationManager
        self.dropMusicRepository = dropMusicRepository
    }

    func drop(adress: String, content: String) -> Single<String> {
        return dropMusicRepository.dropMusic(droppingInfo: self, adress: adress, content: content)
    }
}
