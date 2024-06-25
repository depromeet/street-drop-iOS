//
//  DefaultSettingRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

import Moya
import RxSwift

final class DefaultSettingsRepository: SettingsRepository {
    private let networkManager: NetworkManager
    private let myInfoStorage: MyInfoStorage
    private let disposeBag: DisposeBag = .init()
    
    init(
        networkManager: NetworkManager = .init(),
        myInfoStorage: MyInfoStorage = UserDefaultsMyInfoStorage()
    ) {
        self.networkManager = networkManager
        self.myInfoStorage = myInfoStorage
    }
    
    func fetchMymusicAppFromLocal() -> Single<MusicApp> {
        return Single<MusicApp>.create { [weak self] observer in
            if let musicApp = self?.myInfoStorage.fetchMyInfo()?.musicApp {
                observer(.success(musicApp))
            } else {
                observer(.failure(UserDefaultsError.noData))
            }
            
            return Disposables.create()
        }
    }
    
    func updateUsersMusicAppToServer(musicAppQueryString: String) -> Single<MusicApp> {
        return networkManager.request(
            target: .init(
                NetworkService.patchUsersMusicApp(musicAppQuery: musicAppQueryString)
            ),
            responseType: MyInfoResponseDTO.self
        )
        .flatMap { [weak self] dto in
            guard let self = self else { throw AsynchronousError.closureSelfDeInitiation }
            return myInfoStorage.saveMyInfo(myInfo: dto.toEntity())
                .map {
                    var savedMusicApp: MusicApp = .youtubeMusic
                    switch dto.musicApp {
                    case "youtubemusic":
                        savedMusicApp = MusicApp.youtubeMusic
                    case "spotify":
                        savedMusicApp = MusicApp.spotify
                    default:
                        savedMusicApp = MusicApp.youtubeMusic
                    }
                    return savedMusicApp
                }
        }
    }
    
    func fetchDefaultSettingSectionTypes() -> [SettingSectionType] {
        [
            SettingSectionType(
                section: .appSettings,
                items: [.musicApp(.spotify), .pushNotifications]
            ),
            SettingSectionType(
                section: .servicePolicies,
                items: [.notice(false), .serviceUsageGuide, .privacyPolicy, .feedback]
            )
        ]
    }
    
    func fetchLastSeenNoticeIdFromLocal() -> Single<Int?> {
        Single.create { [weak self] observer in
            let noticeId = self?.myInfoStorage.fetchLastSeenNoticeId()
            observer(.success(noticeId))
            return Disposables.create()
        }
    }
    
    func checkNewNotice(lastNoticeId: Int?) -> Single<Bool> {
        networkManager.checkNewNotice(lastNoticeId: lastNoticeId)
            .map({ noticeUpdate in
                return noticeUpdate.hasNewNotice
            })
    }
}
