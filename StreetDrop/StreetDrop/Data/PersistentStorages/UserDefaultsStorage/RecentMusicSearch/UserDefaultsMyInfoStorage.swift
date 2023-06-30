//
//  UserDefaultsMyInfoStorage.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

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

    func saveMyInfo(myInfo: MyInfo) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(myInfo) {
            userDefaults.set(encodedData, forKey: UserDefaultKey.myUserInfo)
            userDefaults.synchronize()
        }
    }
}
