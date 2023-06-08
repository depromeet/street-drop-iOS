//
//  SearchingMusicModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import RxSwift

protocol SearchingMusicModel {
    func fetchMusic(keyword: String) -> Single<[Music]>
    func saveRecentSearch(keyword: String)
    func fetchRecentSearch() -> Single<[String]>
}

final class DefaultSearchingMusicModel: SearchingMusicModel {
    private let searchingMusicRepository: SearchingMusicRepository
    
    init(searchingMusicRepository: SearchingMusicRepository = DefaultSearchingMusicRepository()) {
        self.searchingMusicRepository = searchingMusicRepository
    }
    
    // FIXME: 클린아키텍처로 리팩토링 시, 반환값을 [SearchedMusicResponseDTO.Music]가 아닌 Music이라는 Entity를 만들어 반환하도록 함
    func fetchMusic(keyword: String) -> Single<[Music]> {
        return searchingMusicRepository.fetchMusic(keyword: keyword)
    }
    
    func saveRecentSearch(keyword: String) {
        self.searchingMusicRepository.saveMusic(keyword: keyword)
    }
    
    func fetchRecentSearch() -> Single<[String]> {
        return self.searchingMusicRepository.fetchRecentMusicQueries()
    }
}
