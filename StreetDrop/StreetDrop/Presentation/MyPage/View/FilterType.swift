//
//  FilterType.swift
//  StreetDrop
//
//  Created by thoonk on 7/19/24.
//

import Foundation

enum FilterType {
    case newest
    case oldest
    case mostPopular
    
    var title: String {
        switch self {
        case .newest:
            return "최신순"
        case .oldest:
            return "오래된순"
        case .mostPopular:
            return "인기순"
        }
    }
}
