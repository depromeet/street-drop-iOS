//
//  UserDefaultsRecentMusicSearches.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/24.
//

import Foundation

final class UserDefaultsRecentMusicQueriesStorage {
    private let maxStorageLimit: Int
    private var userDefaults: UserDefaults
    private let backgroundQueue: DispatchQueue
    
    init(
        maxStorageLimit: Int,
        userDefaults: UserDefaults = UserDefaults.standard,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
        self.backgroundQueue = backgroundQueue
    }

    private func fetchRecentMusicQueries() -> RecentMusicQueryDTOList {
        if let queriesData = userDefaults.object(forKey: UserDefaultKey.recentsMusicSearchesKey) as? Data {
            if let movieQueryList = try? JSONDecoder().decode(RecentMusicQueryDTOList.self, from: queriesData) {
                return movieQueryList
            }
        }
        return RecentMusicQueryDTOList(list: [])
    }

    private func persist(recentMusicQueries: [RecentMusicQueryDTO]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(RecentMusicQueryDTOList(list: recentMusicQueries)) {
            userDefaults.set(encoded, forKey: UserDefaultKey.recentsMusicSearchesKey)
            userDefaults.synchronize()
        }
    }
}

extension UserDefaultsRecentMusicQueriesStorage: RecentMusicQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[RecentMusicQueryDTO], Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchRecentMusicQueries().list
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(
        query: RecentMusicQueryDTO,
        completion: @escaping (Result<RecentMusicQueryDTO, Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchRecentMusicQueries().list
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(recentMusicQueries: queries)
            completion(.success(query))
        }
    }
    
    func deleteRecentQuery(query: RecentMusicQueryDTO) async {
        var queries = self.fetchRecentMusicQueries().list
        self.cleanUpQueries(for: query, in: &queries)
        self.persist(recentMusicQueries: queries)
    }
}


// MARK: - Private
extension UserDefaultsRecentMusicQueriesStorage {

    private func cleanUpQueries(for query: RecentMusicQueryDTO, in queries: inout [RecentMusicQueryDTO]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: RecentMusicQueryDTO, in queries: inout [RecentMusicQueryDTO]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [RecentMusicQueryDTO]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
