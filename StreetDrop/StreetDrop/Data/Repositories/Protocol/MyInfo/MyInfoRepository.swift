//
//  MyInfoRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/23.
//

import Foundation

import RxSwift

protocol MyInfoRepository {
    func fetchMyInfoFromServer() -> Single<MyInfo>
    func saveMyInfo(_ myInfo: MyInfo) -> Single<Void>
    func fetchMyUserIDFromStorage() -> Int?
    func fetchMyMusicAppFromStorage() -> String?
    func checkLaunchedBefore() -> Bool
    func fetchUserCircleRadius() -> Single<Double>
}
