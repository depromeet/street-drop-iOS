//
//  NoticeUseCase.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import RxSwift

protocol NoticeUseCase {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

final class DefaultNoticeUseCase: NoticeUseCase {
    private let noticeRepository: NoticeRepository
    
    init(noticeRepository: NoticeRepository = DefaultNoticeRepository()) {
        self.noticeRepository = noticeRepository
    }
    
    func fetchNoticeList() -> Single<[NoticeEntity]> {
        return noticeRepository.fetchNoticeList()
    }
    
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity> {
        return noticeRepository.fetchNoticeDetail(id: id)
    }
}
