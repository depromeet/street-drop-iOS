//
//  SettingsModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

import RxSwift

protocol SettingsModel {
    func updateUsersMusicAppToServer(musicAppQueryString: String) -> Single<MusicApp>
    func fetchMymusicAppFromLocal() -> Single<MusicApp>
}

final class DefaultSettingsModel: SettingsModel {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository = DefaultSettingsRepository()) {
        self.settingsRepository = settingsRepository
    }
    
    func updateUsersMusicAppToServer(musicAppQueryString: String) -> Single<MusicApp> {
        return settingsRepository.updateUsersMusicAppToServer(musicAppQueryString: musicAppQueryString)
    }
    
    func fetchMymusicAppFromLocal() -> Single<MusicApp> {
        return settingsRepository.fetchMymusicAppFromLocal()
    }
}
