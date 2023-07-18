//
//  MyPageModel.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift

protocol MyPageModel {
    func fetchMyDropList() -> Single<TotalMyMusics>
    func fetchMyLikeList() -> Single<TotalMyMusics>
    func fetchMyLevel() -> Single<MyLevel>
}

final class DefaultMyPageModel: MyPageModel {
    private let repository: MyPageRepository

    init(
        repository: MyPageRepository
    ) {
        self.repository = repository
    }
    
    func fetchMyDropList() -> Single<TotalMyMusics> {
        return repository.fetchMyDropList()
    }
    
    func fetchMyLikeList() -> Single<TotalMyMusics> {
        return repository.fetchMyLikeList()
    }
    
    func fetchMyLevel() -> Single<MyLevel> {
        return repository.fetchMyLevel()
    }
}
