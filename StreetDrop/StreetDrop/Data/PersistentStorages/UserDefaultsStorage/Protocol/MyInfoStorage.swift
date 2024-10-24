//
//  MyInfoStorage.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

protocol MyInfoStorage {
    func fetchMyInfo() -> MyInfo?
    func saveMyInfo(myInfo: MyInfo) -> Single<Void>
    func fetchLaunchedBefore() -> Bool
    func saveLauchedBefore(_ launchedBefore: Bool)
    func fetchLastSeenNoticeId() -> Int?
    func saveLastSeenNoticeId(_ noticeId: Int)
}
