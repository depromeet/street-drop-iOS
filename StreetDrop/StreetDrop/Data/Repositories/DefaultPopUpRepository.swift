//
//  DefaultPopUpRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

import RxSwift

final class DefaultPopUpRepository: PopUpRepository {
    private struct EmptyResponse: Decodable {} // editNickName 메소드 responseType이 Void인데 해당 데이터타입이 Decodable를 준수하지 않아, 임의의 Decodable Struct 생성
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchPopUpInfomation() -> Single<[PopUpInfomation]> {
        return networkManager.request(
            target: .init(NetworkService.getPopUpInfomation),
            responseType: FetchingPopUpInfomationResponseDTO.self
        )
        .map { dto in
            return dto.toEntityList()
        }
    }
    
    func postPopUpUserReading(type: String, id: Int) -> Single<Void> {
        return networkManager.request(
            target: .init(
                NetworkService.postPopUpUserReading(
                    requestDTO: .init(type: type, id: id)
                )
            ),
            responseType: EmptyResponse.self
        )
        .map { _ in Void() }
    }
}
