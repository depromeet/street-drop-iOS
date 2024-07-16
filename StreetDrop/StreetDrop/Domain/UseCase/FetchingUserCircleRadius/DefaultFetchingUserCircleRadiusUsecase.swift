//
//  DefaultFetchingUserCircleRadiusUsecase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2/6/24.
//

import Foundation

import RxSwift

final class DefaultFetchingUserCircleRadiusUsecase: FetchingUserCircleRadiusUsecase {
    private let myInfoRepository: MyInfoRepository
    
    init(
        myInfoRepository: MyInfoRepository = DefaultMyInfoRepository(
            networkManager: .init(),
            myInfoStorage: UserDefaultsMyInfoStorage()
        )
    ) {
        self.myInfoRepository = myInfoRepository
    }
    
    func execute() -> Single<Double> {
        return myInfoRepository.fetchUserCircleRadius()
    }
}
