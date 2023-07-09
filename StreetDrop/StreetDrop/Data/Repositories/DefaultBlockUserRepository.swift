//
//  DefaultBlockUserRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/09.
//

import Foundation

import RxSwift

final class DefaultBlockUserRepository: BlockUserRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultBlockUserRepository {
    func blockUser(_ blockUserID: Int) -> Single<Int> {
        return networkManager.blockUser(blockUserID)
    }
}

