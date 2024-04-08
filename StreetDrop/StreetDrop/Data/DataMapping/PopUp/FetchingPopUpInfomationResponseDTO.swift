//
//  FetchingPopUpInfomationResponseDTO.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

struct FetchingPopUpInfomationResponseDTO: Decodable {
    let data: [Self.Data]
    
    struct Data: Decodable {
        let type: String
        let content: Content
        struct Content: Decodable {
            let id: Int
            let popupName: String
            let title: String
            let description: String
            let remainCount: Int?
        }
    }
}

extension FetchingPopUpInfomationResponseDTO {
    func toEntityList() -> [PopUpInfomation] {
        return data.map {
            .init(
                type: $0.type,
                contentID: $0.content.id,
                popupName: $0.content.popupName,
                contentTitle: $0.content.title,
                contentDescription: $0.content.description,
                levelUpRemainCount: $0.content.remainCount
            )
        }
    }
}
