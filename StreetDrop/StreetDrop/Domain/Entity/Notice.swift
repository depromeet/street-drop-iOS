//
//  Notice.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

struct Notice: Hashable {
    let uuid = UUID()
    let noticeId: Int
    let title: String
    let createdAt: String?
}

struct NoticeDetail: Hashable {
    let uuid = UUID()
    let noticeId: Int
    let title: String
    let content: String
    let createdAt: String?
}

struct NoticeEntity {
    let noticeId: Int
    let title: String
    let createdAt: String
}

struct NoticeDetailEntity {
    let noticeId: Int
    let title: String
    let content: String
    let createdAt: String
}
