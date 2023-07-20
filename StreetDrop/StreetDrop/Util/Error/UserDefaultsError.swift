//
//  UserDefaultsError.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

enum UserDefaultsError: Error {
    case noData
}

extension UserDefaultsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "UserDefaults 값을 가져오지 못함"
        }
    }
}
