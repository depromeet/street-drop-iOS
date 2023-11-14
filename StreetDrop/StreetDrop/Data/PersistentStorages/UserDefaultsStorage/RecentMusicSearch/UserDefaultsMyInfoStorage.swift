//
//  UserDefaultsMyInfoStorage.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

final class UserDefaultsMyInfoStorage {
    private var userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}

extension UserDefaultsMyInfoStorage: MyInfoStorage {
    func fetchMyInfo() -> MyInfo? {
        guard let data = userDefaults.object(forKey: UserDefaultKey.myUserInfo) as? Data,
              let myInfo = try? JSONDecoder().decode(MyInfo.self, from: data) else {
            return nil
        }

        return myInfo
    }

    func saveMyInfo(myInfo: MyInfo) -> Single<Void> {
        return Single.create { [weak self] observer in
            let encoder = JSONEncoder()
            guard let encodedData = try? encoder.encode(myInfo) else {
                observer(.failure(MyInfoError.encodeError))
                return Disposables.create()
            }
            
            self?.userDefaults.set(encodedData, forKey: UserDefaultKey.myUserInfo)
            self?.userDefaults.synchronize()
            observer(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func fetchLaunchedBefore() -> Bool {
        return userDefaults.bool(forKey: UserDefaultKey.launchedBefore)
    }
    
    func saveLauchedBefore(_ launchedBefore: Bool) {
        userDefaults.set(launchedBefore, forKey: UserDefaultKey.launchedBefore)
    }
}
