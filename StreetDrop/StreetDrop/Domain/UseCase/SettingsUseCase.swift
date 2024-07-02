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
    func fetchDefaultSettingSectionTypes() -> [SettingSectionType]
    func fetchLastSeenNoticeId() -> Single<Int?>
    func checkNewNotice(lastNoticeId: Int?) -> Single<Bool>
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
    
    func fetchDefaultSettingSectionTypes() -> [SettingSectionType] {
        return settingsRepository.fetchDefaultSettingSectionTypes()
    }
    
    func fetchLastSeenNoticeId() -> Single<Int?> {
        return settingsRepository.fetchLastSeenNoticeIdFromLocal()
    }
    
    func checkNewNotice(lastNoticeId: Int?) -> Single<Bool> {
        return settingsRepository.checkNewNotice(lastNoticeId: lastNoticeId)
    }
}
