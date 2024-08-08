//
//  FetchingRegionFilteredLikeCountUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/8/24.
//

import Foundation

import RxSwift

protocol FetchingRegionFilteredLikeCountUseCase {
    func execute(state: String, city: String) -> Single<Int>
}

final class DefaultFetchingRegionFilteredLikeCountUseCase: FetchingRegionFilteredLikeCountUseCase {
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository = DefaultMyPageRepository()) {
        self.myPageRepository = myPageRepository
    }
    
    func execute(state: String, city: String) -> Single<Int> {
        return myPageRepository.fetchRegionFilteredLikeCount(state: state, city: city)
    }
}
