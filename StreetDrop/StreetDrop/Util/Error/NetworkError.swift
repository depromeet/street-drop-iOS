//
//  NetworkError.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/08.
//

import Foundation

enum NetworkError: Error {
    case notConnectedToInternet
    case restError(statusCode: Int? = nil, errorCode: String? = nil, errorMessage: String? = nil)
    case timeout
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notConnectedToInternet, .timeout:
            return "네트워크 연결 상태를 확인해주세요."
            //TODO: 네트워크 에러에 대한 사용자 UX처리 회의 이후 변경할 예정
        case .restError(statusCode: let statusCode, errorCode: let errorCode, errorMessage: let errorMessage):
            return "네트워크 연결 상태를 확인해주세요."
        }
    }
}
