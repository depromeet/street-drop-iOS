//
//  MyMusic.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation
import RxDataSources

struct MyMusic {
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
}

struct MyMusics {
    let date: String
    let musics: [MyMusic]
}

struct TotalMyMusics {
    let musics: [MyMusics]
    let totalCount: Int
}

struct MyMusicsSection {
    var date: String
    var items: [Item]
    
    init(date: String, items: [MyMusic]) {
        self.date = date
        self.items = items
    }
}

extension MyMusicsSection: SectionModelType {
    typealias Item = MyMusic
    
    init(original: MyMusicsSection, items: [MyMusic]) {
        self = original
        self.items = items
    }
}
