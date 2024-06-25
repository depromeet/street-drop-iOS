//
//  AsynchronousError.swift
//  StreetDrop
//
//  Created by 차요셉 on 6/25/24.
//

import Foundation

enum AsynchronousError: Error {
    case closureSelfDeInitiation
}

extension AsynchronousError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .closureSelfDeInitiation:
            return "클로저 속 self 객체가 deInit 되었습니다."
        }
    }
}
