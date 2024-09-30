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
    func fetchMyDropList(filterType: FilterType) -> Single<TotalMyMusics> {
        return networkManager.request(
            target: .init(NetworkService.myDropList(filterType: filterType.param)),
            responseType: MyDropListResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMyLikeList(filterType: FilterType) -> Single<TotalMyMusics> {
        return networkManager.request(
            target: .init(NetworkService.myLikeList(filterType: filterType.param)),
            responseType: MyLikeListResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMyLevel() -> Single<MyLevel> {
        return networkManager.request(
            target: .init(NetworkService.myLevel),
            responseType: MyLevelResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMyLevelProgress() -> Single<MyLevelProgress> {
        return networkManager.request(
            target: .init(NetworkService.myLevelProgress),
            responseType: MyLevelProgressResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchLevelPolicy() -> Single<[LevelPolicy]> {
        return networkManager.request(
            target: .init(NetworkService.levelPolicy),
            responseType: LevelPolicyResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMyDropMusic(itemID: Int) -> Single<Musics> {
        return networkManager.request(
            target: .init(
                NetworkService.getSingleMusic(
                    itemID: itemID
                )
            ),
            responseType: SingleMusicResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
}
