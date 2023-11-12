//
//  SearchMusicUsecase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import RxSwift

protocol SearchMusicUsecase {
    func searchMusic(keyword: String) -> Single<[Music]>
    func saveRecentSearch(keyword: String)
    func getRecentSearches() -> Single<[String]>
    func getVillageName(latitude: Double, longitude: Double) -> Single<String>
    func fetchRecommendSearch() -> Single<RecommendMusic>
}

final class DefaultSearchingMusicUsecase: SearchMusicUsecase {
    private let searchingMusicRepository: SearchingMusicRepository
    
    init(searchingMusicRepository: SearchingMusicRepository = DefaultSearchingMusicRepository()) {
        self.searchingMusicRepository = searchingMusicRepository
    }
    
    // FIXME: 클린아키텍처로 리팩토링 시, 반환값을 [SearchedMusicResponseDTO.Music]가 아닌 Music이라는 Entity를 만들어 반환하도록 함
    func searchMusic(keyword: String) -> Single<[Music]> {
        return searchingMusicRepository.fetchMusic(keyword: keyword)
    }
    
    func saveRecentSearch(keyword: String) {
        self.searchingMusicRepository.saveMusic(keyword: keyword)
    }
    
    func getRecentSearches() -> Single<[String]> {
        return self.searchingMusicRepository.fetchRecentMusicQueries()
    }
    
    func getVillageName(latitude: Double, longitude: Double) -> Single<String> {
        return searchingMusicRepository.fetchVillageName(latitude: latitude, longitude: longitude)
    }

    func fetchRecommendSearch() -> Single<RecommendMusic> {
        return self.searchingMusicRepository.fetchRecommendMusicQueries()
    }
}
