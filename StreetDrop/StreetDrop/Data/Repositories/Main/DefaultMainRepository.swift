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
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension DefaultMainRepository {
    func fetchPoi(lat: Double, lon: Double, distacne: Double) -> Single<Pois> {
        networkManager.getPoi(latitude: lat, longitude: lon, distance: distacne)
            .map({ data in
                let dto = try JSONDecoder().decode(PoiResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchMusicCountByDong(address: String) -> Single<MusicCountEntity> {
        networkManager.getMusicCountByDong(address: address)
            .map({ data in
                let dto = try JSONDecoder().decode(MusicCountByDongResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
}

