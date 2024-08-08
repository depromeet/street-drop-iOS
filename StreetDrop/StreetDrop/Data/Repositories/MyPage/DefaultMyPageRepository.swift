//
//  DefaultMyPageRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift
import OrderedCollections

final class DefaultMyPageRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultMyPageRepository: MyPageRepository {
    func fetchMyDropList() -> Single<TotalMyMusics> {
        return networkManager.request(
            target: .init(NetworkService.myDropList),
            responseType: MyDropListResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
    
    func fetchMyLikeList() -> Single<TotalMyMusics> {
        return networkManager.request(
            target: .init(NetworkService.myLikeList),
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
    
    func fetchCityAndDistricts() throws -> OrderedDictionary<String, [String]> {
        guard let url = Bundle.main.url(forResource: "CityAndDistrictsData", withExtension: "json") else {
            throw JSONLoadError.noBundleURL
        }
        
        guard let data = try? Data(contentsOf: url) else { throw JSONLoadError.convertingURLToDataError }
        
        let decoder: JSONDecoder = .init()
        do {
            let cityAndDistricts = try decoder.decode(CityAndDistrictsDTO.self, from: data)
            return cityAndDistricts.toDictionary()
        } catch {
            throw error
        }
    }
    
    func fetchRegionFilteredDropCount(state: String, city: String) -> Single<Int> {
        return networkManager.request(
            target: .init(
                NetworkService.getRegionFilteredDropCount(state: state, city: city)
            ),
            responseType: RegionFilteredDropCountResponseDTO.self
        )
        .map { dto in
            return dto.numberOfDroppedItem
        }
    }
    
    func fetchRegionFilteredDropList(state: String, city: String) -> Single<TotalMyMusics> {
        return networkManager.request(
            target: .init(
                NetworkService.getRegionFilteredDropList(state: state, city: city)
            ),
            responseType: MyDropListResponseDTO.self
        )
        .map { dto in
            return dto.toEntity()
        }
    }
}
