//
//  DefaultMyInfoRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/23.
//

import Foundation

import RxSwift

final class DefaultMyInfoRepository: MyInfoRepository {
    private let networkManager: NetworkManager
    private let myInfoStorage: MyInfoStorage
    
    init(networkManager: NetworkManager, myInfoStorage: MyInfoStorage) {
        self.networkManager = networkManager
        self.myInfoStorage = myInfoStorage
    }
    
    func fetchMyInfoFromServer() -> Single<MyInfo> {
        return networkManager.request(
            target: .init(
                NetworkService.getMyInfo
            ),
            responseType: MyInfoResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func saveMyInfo(_ myInfo: MyInfo) -> Single<Void> {
        return myInfoStorage.saveMyInfo(myInfo: myInfo)
    }
    
    func fetchMyUserIDFromStorage() -> Int? {
        return myInfoStorage.fetchMyInfo()?.userID
    }
    
    func fetchMyMusicAppFromStorage() -> String? {
        return myInfoStorage.fetchMyInfo()?.musicApp.rawValue
    }
    
    func checkLaunchedBefore() -> Bool {
        let isLaunchedBefore = myInfoStorage.fetchLaunchedBefore()
        if isLaunchedBefore == false {
            myInfoStorage.saveLauchedBefore(true)
        }
        return isLaunchedBefore
    }
    
    func fetchUserCircleRadius() -> Single<Double> {
        return networkManager.request(
            target: .init(NetworkService.userCircleRadius),
            responseType: UserCircleRadiusResponseDTO.self
        )
        .map { dto in
            return Double(dto.distance)
        }
    }
    
    func checkFirstLaunchToday() -> Bool {
        let lastLaunchDate = myInfoStorage.fetchLastLaunchDate()
        myInfoStorage.saveLastLaunchDate(Date())
        
        if let lastLaunchDate {
            return !Calendar.current.isDateInToday(lastLaunchDate)
        } else {
            return true
        }
    }
}
