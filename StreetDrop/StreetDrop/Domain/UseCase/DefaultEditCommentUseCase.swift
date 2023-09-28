//
//  DefaultEditCommentUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/09/17.
//

import Foundation

import RxSwift

final class DefaultEditCommentUseCase: EditCommentUseCase {
    private let editCommentRepository: EditCommentRepository

    init(editCommentRepository: EditCommentRepository = DefaultEditCommentRepository()) {
        self.editCommentRepository = editCommentRepository
    }
    
    func edit(itemId: Int, content: String) -> Single<Int> {
        return editCommentRepository.editComment(itemID: itemId, comment: content)
    }
}
