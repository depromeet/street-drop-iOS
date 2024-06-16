//
//  DefaultNoticeRepository.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import Moya
import RxSwift

final class DefaultNoticeRepository: NoticeRepository {
    private let networkManager: NetworkManager
    private let disposeBag: DisposeBag = .init()
    
    init(
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<NetworkService>()
        )
    ) {
        self.networkManager = networkManager
    }
    
    func fetchNoticeList() -> Single<[NoticeEntity]> {
        networkManager.getNoticeList()
            .map({ data in
                let dto = try JSONDecoder().decode(NoticeListResponseDTO.self, from: data)
                return dto.toEntity()
            })
    }
    
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity> {
        networkManager.getNoticeDetail(id: id)
            .map({ data in
                let dto = try JSONDecoder().decode(NoticeDetailDTO.self, from: data)
                return dto.toEntity()
            })
    }
}
