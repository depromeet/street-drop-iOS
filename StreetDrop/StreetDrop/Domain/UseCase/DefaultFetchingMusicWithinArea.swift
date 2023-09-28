//
//  DefaultFetchingMusicWithinArea.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultFetchingMusicWithinArea: FetchingMusicWithinArea {
    private let mainRepository: MainRepository

    init(mainRepository: MainRepository = DefaultMainRepository(
        networkManager: .init(),
        myInfoStorage: UserDefaultsMyInfoStorage()
    )) {
        self.mainRepository = mainRepository
    }
    
    func execute(lat: Double, lon: Double, distance: Double) -> Single<Musics> {
        return mainRepository.fetchMusicWithinArea(lat: lat, lon: lon, distacne: distance)
    }
}
