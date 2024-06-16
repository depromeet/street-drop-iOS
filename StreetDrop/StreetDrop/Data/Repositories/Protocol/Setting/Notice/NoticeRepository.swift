//
//  NoticeRepository.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import RxSwift

protocol NoticeRepository {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}

