//
//  NoticeUseCase.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import RxSwift

protocol FetchingNoticeUseCase {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

final class DefaultFetchingNoticeUseCase: FetchingNoticeUseCase {
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
