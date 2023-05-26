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
        var address: String
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
    
    private let adressManager: AdressManager
    private let dropMusicRepository: DropMusicRepository

    init(
        location: Location,
        music: Music,
        adressManager: AdressManager = DefaultAdressManager(),
        dropMusicRepository: DropMusicRepository = DefaultDropMusicRepository()
    ) {
        self.location = location
        self.music = music
        self.adressManager = adressManager
        self.dropMusicRepository = dropMusicRepository
    }

    func drop(adress: String, content: String) -> Single<Int> {
        return dropMusicRepository.dropMusic(droppingInfo: self, adress: adress, content: content)
    }
}
