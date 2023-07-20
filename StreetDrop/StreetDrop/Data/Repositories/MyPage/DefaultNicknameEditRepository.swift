//
//  DefaultNicknameEditRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/20.
//

import Foundation

import RxSwift

final class DefaultNicknameEditRepository: NicknameEditRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultNicknameEditRepository {
    func editNickname(nickname: String) -> Single<Void> {
        networkManager.editNickname(nickname: nickname)
    }
}
