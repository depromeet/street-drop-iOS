//
//  CommunityInfo.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import Foundation

struct CommunityInfo {
    let adress: String
    let music: Music
    let comment: String
    let user: User
    let dropDate: String

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
