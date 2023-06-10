//
//  MusicDropModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/10.
//

import Foundation

import RxSwift

struct MusicDropModel {
    private let dropMusicRepository: DropMusicRepository

    init(dropMusicRepository: DropMusicRepository = DefaultDropMusicRepository()) {
        self.dropMusicRepository = dropMusicRepository
    }

    func drop(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return dropMusicRepository.dropMusic(droppingInfo: droppingInfo, content: content)
    }
}
