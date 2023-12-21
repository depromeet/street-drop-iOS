//
//  DefaultFetchingSingleMusicUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/12/21.
//

import Foundation

import RxSwift

final class DefaultFetchingSingleMusicUseCase {
    private let repository: MyPageRepository
    
    init(
        repository: MyPageRepository = DefaultMyPageRepository(networkManager: .init())
    ) {
        self.repository = repository
    }
}

extension DefaultFetchingSingleMusicUseCase: FetchingSingleMusicUseCase {
    func fetchSingleMusic(itemID: Int) -> Single<Musics> {
        return repository.fetchMyDropMusic(itemID: itemID)
    }
}
