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
    private struct EmptyResponse: Decodable {} // editNickName 메소드 responseType이 Void인데 해당 데이터타입이 Decodable를 준수하지 않아, 임의의 Decodable Struct 생성
    
    func editNickname(nickname: String) -> Single<Void> {
        return networkManager.request(
            target: .init(NetworkService.editNickname(nickname: nickname)),
            responseType: EmptyResponse.self
        )
        .map { _ in Void() }
    }
}
