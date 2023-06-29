//
//  DefaultClaimCommentRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/29.
//

import Foundation

import RxSwift

final class DefaultClaimCommentRepository: ClaimCommentRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultClaimCommentRepository {
    func claimComment(itemID: Int, reason: String) -> Single<Int> {
        let claimCommentRequestDTO = ClaimCommentRequestDTO(
            itemID: itemID,
            reason: reason
        )

        return networkManager.claimComment(requestDTO: claimCommentRequestDTO)
    }
}

