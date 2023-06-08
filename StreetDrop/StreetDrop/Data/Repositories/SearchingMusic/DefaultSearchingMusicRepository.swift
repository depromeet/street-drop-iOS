//
//  DefaultSearchingMusicRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import Moya
import RxSwift

final class DefaultSearchingMusicRepository: SearchingMusicRepository {
    private let networkManager: NetworkManager
    private let recentMusicQueriesPersistentStorage: RecentMusicQueriesStorage
    
    //FIXME: 서버 API 구현 완료되면, MoyaProvider<NetworkService>(stubClosure: MoyaProvider.immediatelyStub) -> MoyaProvider<NetworkService>()
    init(
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<NetworkService>()
        ),
        recentMusicQueriesPersistentStorage: RecentMusicQueriesStorage = UserDefaultsRecentMusicQueriesStorage(maxStorageLimit: 10)
    ) {
        self.networkManager = networkManager
        self.recentMusicQueriesPersistentStorage = recentMusicQueriesPersistentStorage
    }
    
    // FIXME: 클린아키텍처로 리팩토링 시, 반환값을 [SearchedMusicResponseDTO.Music]가 아닌 Music이라는 Entity를 만들어 반환하도록 함
    func fetchMusic(keyword: String) -> Single<[Music]> {
        return networkManager.searchMusic(keyword: keyword)
            .map { musicData -> [Music] in
                let searchedMusic = try JSONDecoder().decode(
                    SearchedMusicResponseDTO.self,
                    from: musicData
                )
                return searchedMusic.toEntity()
            }
    }
    
    func saveMusic(keyword: String) {
        self.recentMusicQueriesPersistentStorage.saveRecentQuery(
            query: RecentMusicQueryDTO(query: keyword)) { result in
                switch result {
                case .success(let query):
                    print("최근 검색어 '\(query)' 내부 저장소 저장 성공")
                case .failure(let error):
                    print("최근 검색어 '\(keyword)' 내부 저장소 저장 실패, Error: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchRecentMusicQueries() -> Single<[String]> {
        return Single<[String]>.create { observer in
            self.recentMusicQueriesPersistentStorage.fetchRecentsQueries(maxCount: 10) { result in
                switch result {
                case .success(let recentMusicQueryDTO):
                    observer(.success(recentMusicQueryDTO.map { $0.query }))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
