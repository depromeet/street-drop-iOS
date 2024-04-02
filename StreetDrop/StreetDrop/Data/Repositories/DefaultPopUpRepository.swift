//
//  DefaultPopUpRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

import RxSwift

final class DefaultPopUpRepository: PopUpRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchPopUpInfomation() -> Single<PopUpInfomation> {
        return networkManager.getPopUpInfomation()
            .map { data in
                let dto = try JSONDecoder().decode(
                    FetchingPopUpInfomationResponseDTO.self,
                    from: data
                )
                return dto.toEntity()
            }
    }
}
