//
//  EditModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/02.
//

import Foundation

import RxSwift

struct EditModel {
    private let editCommentRepository: EditCommentRepository

    init(editCommentRepository: EditCommentRepository = DefaultEditCommentRepository()) {
        self.editCommentRepository = editCommentRepository
    }

    func edit(itemId: Int, content: String) -> Single<Int> {
        return editCommentRepository.editComment(itemID: itemId, comment: content)
    }
}
