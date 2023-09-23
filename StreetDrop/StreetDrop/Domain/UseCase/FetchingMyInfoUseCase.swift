//
//  FetchingMyInfoUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/23.
//

import Foundation

protocol FetchingMyInfoUseCase {
    func fetchMyUserIDFromStorage() -> Int?
    func fetchMyMusicAppFromStorage() -> String?
}
