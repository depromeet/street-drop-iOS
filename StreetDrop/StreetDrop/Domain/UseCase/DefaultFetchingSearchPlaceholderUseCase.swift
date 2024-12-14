//
//  DefaultFetchingSearchPlaceholderUseCase.swift
//  StreetDrop
//
//  Created by jihye kim on 14/12/2024.
//

import Foundation

import RxSwift

final class DefaultFetchingSearchPlaceholderUseCase: FetchingSearchPlaceholderUseCase {
    private let myInfoRepository: MyInfoRepository

    init(
        myInfoRepository: MyInfoRepository = DefaultMyInfoRepository(
            networkManager: .init(),
            myInfoStorage: UserDefaultsMyInfoStorage()
        )
    ) {
        self.myInfoRepository = myInfoRepository
    }

    func fetchPromptOfTheDay() -> String? {
        myInfoRepository.fetchPromptOfTheDay()
    }
}
