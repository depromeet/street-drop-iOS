//
//  DefaultFetchingMyLevelUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

final class DefaultFetchingMyLevelUseCase {
    private let repository: MyPageRepository
    
    init(repository: MyPageRepository = DefaultMyPageRepository()) {
        self.repository = repository
    }
}

extension DefaultFetchingMyLevelUseCase: FetchingMyLevelUseCase {
    func fetchMyLevel() -> Single<MyLevel> {
        return repository.fetchMyLevel()
    }
    
    func fetchMyLevelProgress() -> Single<MyLevelProgress> {
        return repository.fetchMyLevelProgress()
    }
}
