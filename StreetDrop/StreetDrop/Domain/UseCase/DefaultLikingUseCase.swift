//
//  DefaultLikeUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultLikingUseCase: LikingUseCase {
    private let likeMusicRepository: LikeMusicRepository
    
    init(
        likeMusicRepository: LikeMusicRepository = DefaultLikeMusicRepository()
    ) {
        self.likeMusicRepository = likeMusicRepository
    }
    
    func likeUp(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeUp(itemID: itemID)
    }
    
    func likeDown(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeDown(itemID: itemID)
    }
}
