//
//  MyMusic.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation
import RxDataSources

struct TotalMyMusics {
    let musics: [MyMusics]
    let totalCount: Int
}

struct MyMusics {
    let date: String
    let musics: [MyMusic]
}

struct MyMusic: Hashable {
    let id: Int
    let userId: Int
    var userName: String
    let userProfileImageURL: String
    let musicApp: String
    let albumImageURL: String
    let singer: String
    let song: String
    let genre: [String]
    let comment: String
    let createdAt: String
    let location: String
    let likeCount: Int
    let isLiked: Bool
    
    private let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MyMusic, rhs: MyMusic) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct MyMusicsSectionType: Hashable {
    let section: MyMusicsSection
    let items: [MyMusic]
    
    private let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MyMusicsSectionType, rhs: MyMusicsSectionType) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

enum MyMusicsSection: Hashable {
    case musics(date: String)
}
