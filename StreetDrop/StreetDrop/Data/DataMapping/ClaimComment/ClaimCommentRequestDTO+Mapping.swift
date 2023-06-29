//
//  ClaimCommentRequestDTO+Mapping.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/29.
//

import Foundation

struct ClaimCommentRequestDTO: Encodable {
    let itemID: Int
    let reason: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case reason
    }
}
