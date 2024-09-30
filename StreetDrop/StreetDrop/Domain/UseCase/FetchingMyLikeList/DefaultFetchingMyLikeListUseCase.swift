//
//  DefaultFetchingMyLikeListUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

final class DefaultFetchingMyLikeListUseCase {
    private let repository: MyPageRepository
    
    init(repository: MyPageRepository = DefaultMyPageRepository()) {
        self.repository = repository
    }
}

extension DefaultFetchingMyLikeListUseCase: FetchingMyLikeListUseCase {
    func fetchMyLikeList(filterType: FilterType) -> Single<TotalMyMusics> {
        return repository.fetchMyLikeList(filterType: filterType)
    }
}
