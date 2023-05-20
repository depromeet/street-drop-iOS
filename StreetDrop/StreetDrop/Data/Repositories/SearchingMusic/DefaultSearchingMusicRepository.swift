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
    
    //FIXME: 서버 API 구현 완료되면, MoyaProvider<NetworkService>(stubClosure: MoyaProvider.immediatelyStub) -> MoyaProvider<NetworkService>()
    init(networkManager: NetworkManager = NetworkManager(provider: MoyaProvider<NetworkService>(stubClosure: MoyaProvider.immediatelyStub))) {
        self.networkManager = networkManager
    }
    
    // FIXME: 클린아키텍처로 리팩토링 시, 반환값을 [SearchedMusicResponseDTO.Music]가 아닌 Music이라는 Entity를 만들어 반환하도록 함
    func fetchMusic(keyword: String) -> Single<[SearchedMusicResponseDTO.Music]> {
        return networkManager.searchMusic(keyword: keyword)
            .map { musicData -> [SearchedMusicResponseDTO.Music] in
                let searchedMusic = try JSONDecoder().decode(
                    SearchedMusicResponseDTO.self,
                    from: musicData
                )
                return searchedMusic.musicList
            }
    }
}
