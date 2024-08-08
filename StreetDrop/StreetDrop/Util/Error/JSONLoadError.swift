//
//  JSONLoadError.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/1/24.
//

import Foundation

enum JSONLoadError: Error {
    case noBundleURL
    case convertingURLToDataError
}

extension JSONLoadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noBundleURL, .convertingURLToDataError:
            return "지역정보를 가져오지 못했습니다.\n\(localizedDescription)"
        }
    }
}
