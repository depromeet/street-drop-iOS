//
//  SettingsUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

import RxSwift

protocol SettingsUseCase {
    func updateUsersMusicApp(musicAppQueryString: String) -> Single<MusicApp>
    func fetchMyMusicApp() -> Single<MusicApp>
}

final class DefaultSettingsUseCase: SettingsUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository = DefaultSettingsRepository()) {
        self.settingsRepository = settingsRepository
    }
    
    func updateUsersMusicApp(musicAppQueryString: String) -> Single<MusicApp> {
        return settingsRepository.updateUsersMusicAppToServer(musicAppQueryString: musicAppQueryString)
    }
    
    func fetchMyMusicApp() -> Single<MusicApp> {
        return settingsRepository.fetchMymusicAppFromLocal()
    }
}
