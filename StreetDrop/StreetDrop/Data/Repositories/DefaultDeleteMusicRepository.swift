//
//  DefaultDeleteMusicRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

final class DefaultDeleteMusicRepository: DeleteMusicRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultDeleteMusicRepository {
    func deleteMusic(itemID: Int) -> Single<Int> {
        return networkManager.requestStatusCode(
            target: .init(
                NetworkService.deleteMusic(
                    itemID: itemID
                )
            )
        )
    }
}
