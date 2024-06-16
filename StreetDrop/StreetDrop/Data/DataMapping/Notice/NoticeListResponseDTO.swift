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
    let announcementId: Int
    let title: String
    let createdAt: String
}

struct NoticeDetailDTO: Decodable {
    let announcementId: Int
    let title: String
    let content: String
    let createdAt: String
}

extension NoticeListResponseDTO {
    func toEntity() -> [NoticeEntity] {
        data.map {
            .init(
                announcementId: $0.announcementId,
                title: $0.title,
                createdAt: $0.createdAt
            )
        }
    }
}

extension NoticeDetailDTO {
    func toEntity() -> NoticeDetailEntity {
        return .init(
            announcementId: announcementId,
            title: title,
            content: content,
            createdAt: createdAt
        )
    }
}
