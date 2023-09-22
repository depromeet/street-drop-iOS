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
    func fetchMyInfo() -> Single<MyInfo> {
        return networkManager.getMyInfo()
            .map({ data in
                let dto = try JSONDecoder().decode(MyInfoResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchPoi(lat: Double, lon: Double, distacne: Double) -> Single<Pois> {
        networkManager.getPoi(latitude: lat, longitude: lon, distance: distacne)
            .map({ data in
                let dto = try JSONDecoder().decode(PoiResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchMusicCountByDong(lat: Double, lon: Double) -> Single<MusicCountEntity> {
        networkManager.getMusicCountByDong(latitude: lat, longitude: lon)
            .map({ data in
                let dto = try JSONDecoder().decode(MusicCountByDongResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchMusicWithinArea(lat: Double, lon: Double, distacne: Double) -> Single<Musics> {
        networkManager.getMusicWithinArea(latitude: lat, longitude: lon, distance: distacne)
            .map({ data in
                let dto = try JSONDecoder().decode(MusicWithinAreaResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func saveMyInfo(_ myInfo: MyInfo) -> RxSwift.Single<Void> {
        return myInfoStorage.saveMyInfo(myInfo: myInfo)
    }
}
