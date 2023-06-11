//
//  CommunityModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/11.
//

import Foundation

import RxSwift

protocol CommunityModel {
    func likeUp(itemID: Int) -> Single<Int>
    func likeDown(itemID: Int) -> Single<Int>
}

final class DefaultCommunityModel: CommunityModel {
    private let likeMusicRepository: LikeMusicRepository

    init(likeMusicRepository: LikeMusicRepository = DefaultLikeMusicRepository()) {
        self.likeMusicRepository = likeMusicRepository
    }
}

extension DefaultCommunityModel {
    func likeUp(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeUp(itemID: itemID)
    }

    func likeDown(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeDown(itemID: itemID)
    }
}
