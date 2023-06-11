//
//  MainModel.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/03.
//

import Foundation

import RxSwift

final class MainModel {
    private let repository: DefaultMainRepository
    
    init(repository: DefaultMainRepository) {
        self.repository = repository
    }
}

extension MainModel {
    func fetchPois(lat: Double, lon: Double, distance: Double) -> Single<Pois> {
        return repository.fetchPoi(lat: lat, lon: lon, distacne: distance)
    }
    
    func fetchMusicCount(address: String) -> Single<MusicCountEntity> {
        return repository.fetchMusicCountByDong(address: address)
    }
    
    func fetchMusicWithinArea(lat: Double, lon: Double, distance: Double) -> Single<Musics> {
        return repository.fetchMusicWithinArea(lat: lat, lon: lon, distacne: distance)
    }
}
