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
    private let myInfoStorage: MyInfoStorage

    init(
        repository: DefaultMainRepository,
        myInfoStorage: MyInfoStorage = UserDefaultsMyInfoStorage()
    ) {
        self.repository = repository
        self.myInfoStorage = myInfoStorage
    }
}

extension MainModel {
    func fetchMyInfo() -> Single<MyInfo> {
        return repository.fetchMyInfo()
    }

    func saveMyInfo(_ myInfo: MyInfo) {
        myInfoStorage.saveMyInfo(myInfo: myInfo)
    }

    func fetchPois(lat: Double, lon: Double, distance: Double) -> Single<Pois> {
        return repository.fetchPoi(lat: lat, lon: lon, distacne: distance)
    }
    
    func fetchMusicCount(lat: Double, lon: Double) -> Single<MusicCountEntity> {
        return repository.fetchMusicCountByDong(lat: lat, lon: lon)
    }
    
    func fetchMusicWithinArea(lat: Double, lon: Double, distance: Double) -> Single<Musics> {
        return repository.fetchMusicWithinArea(lat: lat, lon: lon, distacne: distance)
    }
}
