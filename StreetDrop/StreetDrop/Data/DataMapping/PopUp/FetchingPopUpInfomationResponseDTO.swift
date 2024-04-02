//
//  FetchingPopUpInfomationResponseDTO.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

struct FetchingPopUpInfomationResponseDTO: Decodable {
    let type: String
    let content: Content
    struct Content: Decodable {
        let id: Int
        let title: String
        let description: String
    }
}

extension FetchingPopUpInfomationResponseDTO {
    func toEntity() -> PopUpInfomation {
        return .init(
            type: type,
            contentID: content.id,
            contentTitle: content.title,
            contentDescription: content.description
        )
    }
}
