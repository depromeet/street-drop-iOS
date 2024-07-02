//
//  NoticeListResponseDTO.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

struct NoticeListResponseDTO: Decodable {
    let data: [NoticeDTO]
}

struct NoticeDTO: Decodable {
    let noticeId: Int
    let title: String
    let createdAt: String
}

struct NoticeDetailDTO: Decodable {
    let noticeId: Int
    let title: String
    let content: String
    let createdAt: String
}

struct NoticeUpdateDTO: Decodable {
    let hasNewNotice: Bool
}

// MARK: entity

extension NoticeListResponseDTO {
    var toEntity: [NoticeEntity] {
        data.map {
            .init(
                noticeId: $0.noticeId,
                title: $0.title,
                createdAt: $0.createdAt
            )
        }
    }
}

extension NoticeDetailDTO {
    var toEntity: NoticeDetailEntity {
        .init(
            noticeId: noticeId,
            title: title,
            content: content,
            createdAt: createdAt
        )
    }
}
