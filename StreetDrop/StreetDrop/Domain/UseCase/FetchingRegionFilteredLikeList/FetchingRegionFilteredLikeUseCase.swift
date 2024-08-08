//
//  FetchingRegionFilteredLikeUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/8/24.
//

import Foundation

import RxSwift

protocol FetchingRegionFilteredLikeUseCase {
    func execute(state: String, city: String) -> Single<TotalMyMusics>
}

final class DefaultFetchingRegionFilteredLikeUseCase: FetchingRegionFilteredLikeUseCase {
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository = DefaultMyPageRepository()) {
        self.myPageRepository = myPageRepository
    }
    
    func execute(state: String, city: String) -> Single<TotalMyMusics> {
        return myPageRepository.fetchRegionFilteredLikeList(state: state, city: city)
    }
}
