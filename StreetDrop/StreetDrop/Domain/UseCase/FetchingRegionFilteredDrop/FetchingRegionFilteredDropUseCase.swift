//
//  FetchingRegionFilteredDropUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/8/24.
//

import Foundation

import RxSwift

protocol FetchingRegionFilteredDropUseCase {
    func execute(state: String, city: String) -> Single<TotalMyMusics>
}

final class DefaultFetchingRegionFilteredDropUseCase: FetchingRegionFilteredDropUseCase {
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository = DefaultMyPageRepository()) {
        self.myPageRepository = myPageRepository
    }
    
    func execute(state: String, city: String) -> Single<TotalMyMusics> {
        return myPageRepository.fetchRegionFilteredDropList(state: state, city: city)
    }
}
