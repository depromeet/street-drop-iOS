//
//  DefaultFetchingMyInfoUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/23.
//

import Foundation

import RxSwift

final class DefaultFetchingMyInfoUseCase: FetchingMyInfoUseCase {
    private let myInfoRepository: MyInfoRepository
    
    init(myInfoRepository: MyInfoRepository = DefaultMyInfoRepository(
        networkManager: .init(),
        myInfoStorage: UserDefaultsMyInfoStorage()
    )) {
        self.myInfoRepository = myInfoRepository
    }
    
    func fetchMyUserIDFromStorage() -> Int? {
        return myInfoRepository.fetchMyUserIDFromStorage()
    }
    
    func fetchMyMusicAppFromStorage() -> String? {
        return myInfoRepository.fetchMyMusicAppFromStorage()
    }
}
