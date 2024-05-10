//
//  DefaultFetchingLevelPolicyUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2024/04/16.
//

import Foundation

import RxSwift

final class DefaultFetchingLevelPolicyUseCase {
    private let repository: MyPageRepository
    
    init(repository: MyPageRepository = DefaultMyPageRepository()) {
        self.repository = repository
    }
}

extension DefaultFetchingLevelPolicyUseCase: FetchingLevelPolicyUseCase {
    func fetchLevelPolicy() -> Single<[LevelPolicy]> {
        return repository.fetchLevelPolicy()
    }
}
