//
//  DefaultFetchingMyDropListUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

final class DefaultFetchingMyDropListUseCase {
    private let repository: MyPageRepository
    
    init(repository: MyPageRepository = DefaultMyPageRepository()) {
        self.repository = repository
    }
}

extension DefaultFetchingMyDropListUseCase: FetchingMyDropListUseCase {
    func fetchMyDropList(filterType: FilterType) -> Single<TotalMyMusics> {
        return repository.fetchMyDropList(filterType: filterType)
    }
}
