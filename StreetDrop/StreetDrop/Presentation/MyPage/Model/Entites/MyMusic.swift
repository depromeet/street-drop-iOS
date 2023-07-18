//
//  MyMusic.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

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
