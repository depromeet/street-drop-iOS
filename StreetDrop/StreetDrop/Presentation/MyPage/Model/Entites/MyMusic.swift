//
//  MyMusic.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation
import RxDataSources

struct MyMusic {
    let albumImageURL: String
    let singer: String
    let song: String
    let comment: String
    let location: String
    let likeCount: Int
}

struct MyMusics {
    let date: String
    let musics: [MyMusic]
}

typealias TotalMyMusics = [MyMusics]

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