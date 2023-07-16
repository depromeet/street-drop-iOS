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
    func blockUser(_ blockUserID: Int) -> Single<Int>
    func fetchMyUserID() -> Int?
    func fetchMyMusicApp() -> String?
}

final class DefaultCommunityModel: CommunityModel {
    private let likeMusicRepository: LikeMusicRepository
    private let claimCommentRepository: ClaimCommentRepository
    private let deleteMusicRepository: DeleteMusicRepository
    private let blockUserRepository: BlockUserRepository
    private let myInfoStorage: MyInfoStorage

    init(
        likeMusicRepository: LikeMusicRepository = DefaultLikeMusicRepository(),
        claimCommentRepository: ClaimCommentRepository = DefaultClaimCommentRepository(),
        deleteMusicRepository: DeleteMusicRepository = DefaultDeleteMusicRepository(),
        blockUserRepository: BlockUserRepository = DefaultBlockUserRepository(),
        myInfoStorage: MyInfoStorage = UserDefaultsMyInfoStorage()
    ) {
        self.likeMusicRepository = likeMusicRepository
        self.claimCommentRepository = claimCommentRepository
        self.deleteMusicRepository = deleteMusicRepository
        self.blockUserRepository = blockUserRepository
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

    func blockUser(_ blockUserID: Int) -> Single<Int> {
        return blockUserRepository.blockUser(blockUserID)
    }

    func fetchMyUserID() -> Int? {
        return myInfoStorage.fetchMyInfo()?.userID
    }

    func fetchMyMusicApp() -> String? {
        return myInfoStorage.fetchMyInfo()?.musicApp.rawValue
    }
}
