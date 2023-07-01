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
    func claimComment(itemID: Int, reason: String) -> Single<Int>
    func deleteMusic(itemID: Int) -> Single<Int>
}

final class DefaultCommunityModel: CommunityModel {
    private let likeMusicRepository: LikeMusicRepository
    private let claimCommentRepository: ClaimCommentRepository
    private let deleteMusicRepository: DeleteMusicRepository
    private let myInfoStorage: MyInfoStorage

    init(
        likeMusicRepository: LikeMusicRepository = DefaultLikeMusicRepository(),
        claimCommentRepository: ClaimCommentRepository = DefaultClaimCommentRepository(),
        deleteMusicRepository: DeleteMusicRepository = DefaultDeleteMusicRepository(),
        myInfoStorage: MyInfoStorage = UserDefaultsMyInfoStorage()
    ) {
        self.likeMusicRepository = likeMusicRepository
        self.claimCommentRepository = claimCommentRepository
        self.deleteMusicRepository = deleteMusicRepository
        self.myInfoStorage = myInfoStorage
    }
}

extension DefaultCommunityModel {
    func likeUp(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeUp(itemID: itemID)
    }

    func likeDown(itemID: Int) -> Single<Int> {
        return likeMusicRepository.likeDown(itemID: itemID)
    }

    func claimComment(itemID: Int, reason: String) -> Single<Int> {
        return claimCommentRepository.claimComment(itemID: itemID, reason: reason)
    }

    func deleteMusic(itemID: Int) -> Single<Int> {
        return deleteMusicRepository.deleteMusic(itemID: itemID)
    }
}
