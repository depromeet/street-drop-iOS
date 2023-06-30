//
//  DefaultReviseCommentRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

final class DefaultReviseCommentRepository: ReviseCommentRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultReviseCommentRepository {
    func reviseComment(itemID: Int, comment: String) -> Single<Int> {
        return networkManager.reviseComment(
            itemID: itemID,
            requestDTO: ReviseCommentRequestDTO(content: comment)
        )
    }
}
