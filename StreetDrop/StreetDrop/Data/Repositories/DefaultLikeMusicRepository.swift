//
//  DefaultLikeMusicRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/11.
//

import Foundation

import RxSwift

final class DefaultLikeMusicRepository: LikeMusicRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultLikeMusicRepository {
    func likeUp(itemID: Int) -> Single<Int> {
        return networkManager.postLikeUp(itemID: itemID)
    }

    func likeDown(itemID: Int) -> Single<Int> {
        return networkManager.postLikeDown(itemID: itemID)
    }
}
