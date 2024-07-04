//
//  DefaultMainRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/10.
//

import Foundation

import RxSwift

final class DefaultMainRepository: MainRepository {
    private let networkManager: NetworkManager
    private let myInfoStorage: MyInfoStorage
    
    init(networkManager: NetworkManager, myInfoStorage: MyInfoStorage) {
        self.networkManager = networkManager
        self.myInfoStorage = myInfoStorage
    }
}

extension DefaultMainRepository {
    func fetchPoi(lat: Double, lon: Double, distance: Double) -> Single<Pois> {
        return networkManager.request(
            target: .init(
                NetworkService.getPoi(
                    latitude: lat,
                    longitude: lon,
                    distance: distance
                )
            ),
            responseType: PoiResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMusicCountByDong(lat: Double, lon: Double) -> Single<MusicCountEntity> {
        return networkManager.request(
            target: .init(
                NetworkService.getMusicCountByDong(
                    latitude: lat,
                    longitude: lon
                )
            ),
            responseType: MusicCountByDongResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMusicWithinArea(lat: Double, lon: Double, distance: Double) -> Single<Musics> {
        return networkManager.request(
            target: .init(
                NetworkService.getMusicWithinArea(
                    latitude: lat,
                    longitude: lon,
                    distance: distance
                )
            ),
            responseType: MusicWithinAreaResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
}
