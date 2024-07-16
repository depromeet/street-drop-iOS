//
//  DefaultDropMusicUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/09/17.
//

import Foundation

import RxSwift

final class DefaultDropMusicUseCase: DropMusicUseCase {
    private let dropMusicRepository: DropMusicRepository
    
    init(dropMusicRepository: DropMusicRepository = DefaultDropMusicRepository()) {
        self.dropMusicRepository = dropMusicRepository
    }

    func drop(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return dropMusicRepository.dropMusic(droppingInfo: droppingInfo, content: content)
    }
}
