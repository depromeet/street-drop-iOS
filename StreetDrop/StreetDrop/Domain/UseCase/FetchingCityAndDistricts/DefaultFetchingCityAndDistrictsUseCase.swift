//
//  DefaultFetchingCityAndDistrictsUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/1/24.
//

import Foundation

import OrderedCollections

final class DefaultFetchingCityAndDistrictsUseCase: FetchingCityAndDistrictsUseCase {
    private let myPageRepository: MyPageRepository
    
    init(myPageRepository: MyPageRepository = DefaultMyPageRepository()) {
        self.myPageRepository = myPageRepository
    }
    func execute() throws -> OrderedDictionary<String, [String]> {
        return try myPageRepository.fetchCityAndDistricts()
    }
}
