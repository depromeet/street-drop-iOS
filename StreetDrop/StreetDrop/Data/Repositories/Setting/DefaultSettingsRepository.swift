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
        return networkManager.patchUsersMusicApp(musicAppQueryString: musicAppQueryString)
            .map { [weak self] data in
                let dto = try JSONDecoder().decode(
                    MyInfoResponseDTO.self,
                    from: data
                )
                
                self?.myInfoStorage.saveMyInfo(myInfo: dto.toEntity())
                
                var savedMusicApp: MusicApp = .youtubeMusic
                switch dto.musicApp {
                case "youtubemusic":
                    savedMusicApp = MusicApp.youtubeMusic
                case "spotify":
                    savedMusicApp = MusicApp.spotify
//                case "applemusic":
//                    savedMusicApp = MusicApp.appleMusic
                default:
                    savedMusicApp = MusicApp.youtubeMusic
                }
                
                return savedMusicApp
            }
    }
}
