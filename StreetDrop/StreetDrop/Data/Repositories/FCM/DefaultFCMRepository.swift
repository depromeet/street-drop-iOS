//
//  DefaultFCMRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/12.
//

import Foundation

import RxSwift

final class DefaultFCMRepository: FCMRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func enrollFCMToken(token: String) -> Single<Int> {
        return networkManager.requestStatusCode(
            target: .init(
                NetworkService.postFCMToken(
                    token: .init(token: token)
                )
            )
        )
    }
}
