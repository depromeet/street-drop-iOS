//
//  DefaultFetchingMusicCountUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultFetchingMusicCountUseCase: FetchingMusicCountUseCase {
    private let mainRepository: MainRepository

    init(mainRepository: MainRepository = DefaultMainRepository(
        networkManager: .init(),
        myInfoStorage: UserDefaultsMyInfoStorage()
    )) {
        self.mainRepository = mainRepository
    }
    
    func execute(lat: Double, lon: Double) -> Single<MusicCountEntity> {
        return mainRepository.fetchMusicCountByDong(lat: lat, lon: lon)
    }
}
