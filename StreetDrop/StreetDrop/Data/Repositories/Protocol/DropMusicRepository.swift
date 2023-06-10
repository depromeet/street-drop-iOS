//
//  DropMusicRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/22.
//

import Foundation

import RxSwift

protocol DropMusicRepository {
    func dropMusic(droppingInfo: DroppingInfo, content: String) -> Single<Int>
}
