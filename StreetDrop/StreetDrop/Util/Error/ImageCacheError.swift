//
//  ImageCacheError.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/12.
//

import Foundation

enum ImageCacheError: Error {
    case nilPathError
    case nilImageError
    case invalidURLError
    case imageNotModifiedError
    case networkUsageExceedError
    case unknownNetworkError
}
