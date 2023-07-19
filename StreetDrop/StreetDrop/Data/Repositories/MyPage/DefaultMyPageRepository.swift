//
//  DefaultMyPageRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift

final class DefaultMyPageRepository: MyPageRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultMyPageRepository {
    func fetchMyDropList() -> Single<TotalMyMusics> {
        networkManager.getMyDropList()
            .map({ data in
                let dto = try JSONDecoder().decode(MyDropListResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchMyLikeList() -> Single<TotalMyMusics> {
        networkManager.getMyLikeList()
            .map({ data in
                let dto = try JSONDecoder().decode(MyLikeListResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchMyLevel() -> Single<MyLevel> {
        networkManager.getMyLevel()
            .map({ data in
                let dto = try JSONDecoder().decode(MyLevelResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
}
