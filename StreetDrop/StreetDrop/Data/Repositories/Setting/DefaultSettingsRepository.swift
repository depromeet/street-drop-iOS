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
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<NetworkService>()
        ),
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
        return Single.create { [weak self] observer in
            guard let self = self else { return Disposables.create()}
            networkManager.patchUsersMusicApp(musicAppQueryString: musicAppQueryString)
                .subscribe { data in
                    do {
                        let dto = try JSONDecoder().decode(MyInfoResponseDTO.self, from: data)
                        
                        self.myInfoStorage.saveMyInfo(myInfo: dto.toEntity())
                            .subscribe(onSuccess: {
                                var savedMusicApp: MusicApp = .youtubeMusic
                                switch dto.musicApp {
                                case "youtubemusic":
                                    savedMusicApp = MusicApp.youtubeMusic
                                case "spotify":
                                    savedMusicApp = MusicApp.spotify
//                                case "applemusic":
//                                    savedMusicApp = MusicApp.appleMusic
                                default:
                                    savedMusicApp = MusicApp.youtubeMusic
                                }
                                observer(.success(savedMusicApp))
                            }, onFailure: { error in
                                observer(.failure(error))
                            })
                            .disposed(by: self.disposeBag)
                    } catch {
                        observer(.failure(error))
                    }
                } onFailure: { error in
                    observer(.failure(error))
                }
                .disposed(by: disposeBag)
            
            return Disposables.create()
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
