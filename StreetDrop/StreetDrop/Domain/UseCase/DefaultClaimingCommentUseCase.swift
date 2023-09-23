//
//  DefaultClaimUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultClaimingCommentUseCase: ClaimingCommentUseCase {
    private let claimCommentRepository: ClaimCommentRepository
    
    init(
        claimCommentRepository: ClaimCommentRepository = DefaultClaimCommentRepository()
    ) {
        self.claimCommentRepository = claimCommentRepository
    }
    
    func execute(itemID: Int, reason: String) -> Single<Int> {
        return claimCommentRepository.claimComment(itemID: itemID, reason: reason)
    }
}
