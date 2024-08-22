// DefaultDropMusicRepository.swift
// StreetDrop
//
// Created by 맹선아 on 2023/05/22.
//

import Foundation

import RxSwift

final class DefaultDropMusicRepository {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultDropMusicRepository: DropMusicRepository {
    func dropMusicResponsingOnlyStatusCode(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return networkManager.requestStatusCode(
            target: .init(
                NetworkService.dropMusic(
                    requestDTO: .init(
                        location: DropMusicRequestDTO.Location(
                            latitude: droppingInfo.location.latitude,
                            longitude: droppingInfo.location.longitude,
                            address: droppingInfo.location.address
                        ),
                        music: DropMusicRequestDTO.Music(
                            title: droppingInfo.music.songName,
                            artist: droppingInfo.music.artistName,
                            albumName: droppingInfo.music.albumName,
                            albumImage: droppingInfo.music.albumImage,
                            genre: droppingInfo.music.genre
                        ),
                        content: content
                    )
                )
            )
        )
    }
    
    func dropMusicResponsingOnlyItemID(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return networkManager.request(
            target: .init(
                NetworkService.dropMusic(
                    requestDTO: .init(
                        location: DropMusicRequestDTO.Location(
                            latitude: droppingInfo.location.latitude,
                            longitude: droppingInfo.location.longitude,
                            address: droppingInfo.location.address
                        ),
                        music: DropMusicRequestDTO.Music(
                            title: droppingInfo.music.songName,
                            artist: droppingInfo.music.artistName,
                            albumName: droppingInfo.music.albumName,
                            albumImage: droppingInfo.music.albumImage,
                            genre: droppingInfo.music.genre
                        ),
                        content: content
                    )
                )
            ), 
            responseType: DropMusicReponseDTO.self
        )
        .map { dto in
            return dto.itemId
        }
    }
}
