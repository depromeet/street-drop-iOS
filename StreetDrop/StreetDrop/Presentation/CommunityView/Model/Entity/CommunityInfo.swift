//
//  CommunityInfo.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import Foundation

struct CommunityInfo {
    let itemID: Int
    let address: String
    let music: Music
    let comment: String
    let user: User
    let dropDate: String
    var isLiked: Bool
    var likeCount: Int

    struct Music {
        let title: String
        let artist: String
        let albumImage: String
        let genre: [String]
    }

    struct User {
        let nickname: String
        let profileImage: String
        let musicApp: String
    }
}