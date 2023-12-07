//
//  SearchingMusicRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import RxSwift

protocol SearchingMusicRepository {
    func fetchMusic(keyword: String) -> Single<[Music]>
    func saveMusic(keyword: String)
    func fetchRecommendMusicQueries() -> Single<RecommendMusic>
    func fetchRecentMusicQueries() -> Single<[String]>
    func fetchVillageName(latitude: Double, longitude: Double) -> Single<String>
}
