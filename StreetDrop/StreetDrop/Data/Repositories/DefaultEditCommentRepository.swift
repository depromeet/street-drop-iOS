//
//  DefaultEditCommentRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

final class DefaultEditCommentRepository: EditCommentRepository {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DefaultEditCommentRepository {
    func editComment(itemID: Int, comment: String) -> Single<Int> {
        return networkManager.editComment(
            itemID: itemID,
            requestDTO: EditCommentRequestDTO(content: comment)
        )
    }
}
