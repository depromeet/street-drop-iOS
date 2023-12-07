//
//  RecentMusicQueriesStorage.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/24.
//

import Foundation

protocol RecentMusicQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[RecentMusicQueryDTO], Error>) -> Void
    )
    func saveRecentQuery(
        query: RecentMusicQueryDTO,
        completion: @escaping (Result<RecentMusicQueryDTO, Error>) -> Void
    )
}

protocol RecommendMusicQueriesStorage {
    func fetchRecommendQueries(completion: @escaping (Result<[RecommendMusic], Error>) -> Void)
}
