//
//  DefaultMyInfoUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultMyInfoUseCase: MyInfoUseCase {
    private let mainRepository: MainRepository
    private let myInfoRepository: MyInfoRepository
    
    init(
        mainRepository: MainRepository = DefaultMainRepository(
            networkManager: .init(),
            myInfoStorage: UserDefaultsMyInfoStorage()
        ),
        myInfoRepository: MyInfoRepository = DefaultMyInfoRepository(
            networkManager: .init(),
            myInfoStorage: UserDefaultsMyInfoStorage()
        )
    ) {
        self.mainRepository = mainRepository
        self.myInfoRepository = myInfoRepository
    }
    
    func fetchMyInfo() -> Single<MyInfo> {
        return myInfoRepository.fetchMyInfoFromServer()
    }
    
    func saveMyInfo(_ myInfo: MyInfo) -> Single<Void> {
        return myInfoRepository.saveMyInfo(myInfo)
    }
    
    func checkLaunchedBefore() -> Bool {
        return myInfoRepository.checkLaunchedBefore()
    }
    
    func checkFirstLaunchToday() -> Bool {
        return myInfoRepository.checkFirstLaunchToday()
    }
}
