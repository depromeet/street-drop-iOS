//
//  SettingsRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

import RxSwift

protocol SettingsRepository {
    func fetchMymusicAppFromLocal() -> Single<MusicApp>
    func updateUsersMusicAppToServer(musicAppQueryString: String) -> Single<MusicApp>
    func fetchDefaultSettingSectionTypes() -> [SettingSectionType]
}
