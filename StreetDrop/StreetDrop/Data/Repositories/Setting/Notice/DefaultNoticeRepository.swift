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
    private let myInfoStorage: MyInfoStorage
    
    private let disposeBag: DisposeBag = .init()
    
    init(
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<NetworkService>()
        ),
        myInfoStorage: MyInfoStorage = UserDefaultsMyInfoStorage()
    ) {
        self.networkManager = networkManager
        self.myInfoStorage = myInfoStorage
    }
    
    func fetchNoticeList() -> Single<[NoticeEntity]> {
        networkManager.getNoticeList()
            .map { [weak self] noticeListDTO in
                let notices = noticeListDTO.toEntity
                
                if let self,
                   let lastNotice = notices.last {
                    self.myInfoStorage.saveLastSeenNoticeId(lastNotice.noticeId)
                }
                
                return notices
            }
    }
    
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity> {
        networkManager.getNoticeDetail(id: id)
            .map(\.toEntity)
    }
}
