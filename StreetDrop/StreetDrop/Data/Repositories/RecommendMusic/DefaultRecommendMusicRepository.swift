//
//  DefaultRecommendMusicRepository.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import Moya
import RxSwift

final class DefaultRecommendMusicRepository: RecommendMusicRepository {
    private let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<MultiTarget>()
        )
    ) {
        self.networkManager = networkManager
    }
    
    func fetchRecommendSectionList() -> Single<[RecommendSectionDTO]> {
        return networkManager.request(
            target: .init(NetworkService.getRecommendList),
            responseType: RecommendSectionResponse.self
        )
        .map { $0.data }
    }

    func fetchPromptOfTheDay() -> Single<String?> {
        return networkManager.request(
            target: .init(NetworkService.getPromptOfTheDay),
            responseType: PromptOfTheDayResponse.self
        )
        .map { $0.sentence }
    }
}
