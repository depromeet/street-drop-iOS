//
//  DefaultMyInfoRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

final class DefaultMyInfoRepository: MyInfoRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultMyInfoRepository {
    func GetMyInfo() -> Single<MyInfo> {
        return networkManager.getMyInfo()
            .map({ data in
                let dto = try JSONDecoder().decode(MyInfoResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
}
