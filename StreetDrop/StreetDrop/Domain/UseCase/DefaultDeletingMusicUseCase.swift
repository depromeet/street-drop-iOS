//
//  DefaultDeletingMusicUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultDeletingMusicUseCase: DeletingMusicUseCase {
    private let deleteMusicRepository: DeleteMusicRepository
    
    init(
        deleteMusicRepository: DeleteMusicRepository = DefaultDeleteMusicRepository()
    ) {
        self.deleteMusicRepository = deleteMusicRepository
    }
    
    func execute(itemID: Int) -> Single<Int> {
        return deleteMusicRepository.deleteMusic(itemID: itemID)
    }
}
