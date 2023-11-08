//
//  DefaultMyPageRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift

final class DefaultMyPageRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultMyPageRepository: MyPageRepository {
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
    
    func fetchMyDropMusic(itemID: Int) -> Single<Musics> {
        networkManager.getSingleMusic(itemID: itemID)
            .map({ data in
                let dto = try JSONDecoder().decode(
                    SingleMusicResponseDTO.self,
                    from: data
                )
                return dto.toEntity()
            })
    }
}
