//
//  RecommendMusicUsecase.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import RxSwift

protocol RecommendMusicUsecase {
    func getPromptOfTheDay() -> Single<String?>
    func getRecommendSections() -> Single<[RecommendSectionDTO]>
}

final class DefaultRecommendMusicUsecase: RecommendMusicUsecase {
    private let recommendMusicRepository: RecommendMusicRepository
    
    init(recommendMusicRepository: RecommendMusicRepository = DefaultRecommendMusicRepository()) {
        self.recommendMusicRepository = recommendMusicRepository
    }
    
    func getPromptOfTheDay() -> Single<String?> {
        recommendMusicRepository.fetchPromptOfTheDay()
    }
    
    func getRecommendSections() -> Single<[RecommendSectionDTO]> {
        recommendMusicRepository.fetchRecommendSectionList()
    }
}
