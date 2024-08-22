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

    func dropMusicResponsingOnlyStatusCode(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return dropMusicRepository.dropMusicResponsingOnlyStatusCode(droppingInfo: droppingInfo, content: content)
    }
    
    func dropMusicResponsingOnlyItemID(droppingInfo: DroppingInfo, content: String) -> Single<Int> {
        return dropMusicRepository.dropMusicResponsingOnlyItemID(droppingInfo: droppingInfo, content: content)
    }
}
