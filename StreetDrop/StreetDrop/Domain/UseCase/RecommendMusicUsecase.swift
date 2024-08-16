//
//  RecommendMusicUsecase.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import RxSwift

protocol RecommendMusicUsecase {
    func getPromptOfTheDay() -> Single<String>
    func getTrendingMusicList() -> Single<[Music]>
    func getMostDroppedMusicList() -> Single<[Music]>
    func getArtistList() -> Single<[Artist]>
}

final class DefaultRecommendMusicUsecase: RecommendMusicUsecase {
    private let recommendMusicRepository: RecommendMusicRepository
    
    init(recommendMusicRepository: RecommendMusicRepository = DefaultRecommendMusicRepository()) {
        self.recommendMusicRepository = recommendMusicRepository
    }
    
    func getPromptOfTheDay() -> Single<String> {
        recommendMusicRepository.fetchPromptOfTheDay()
    }
    
    func getTrendingMusicList() -> Single<[Music]> {
        recommendMusicRepository.fetchTrendingMusicList()
    }
    
    func getMostDroppedMusicList() -> Single<[Music]> {
        recommendMusicRepository.fetchMostDroppedMusicList()
    }
    
    func getArtistList() -> Single<[Artist]> {
        recommendMusicRepository.fetchArtistList()
    }
}
