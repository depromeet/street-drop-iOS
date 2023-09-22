//
//  MyInfoError.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

enum MyInfoError: Error {
    case encodeError
}

extension MyInfoError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .encodeError:
            return "encodeError"
        }
    }
}
