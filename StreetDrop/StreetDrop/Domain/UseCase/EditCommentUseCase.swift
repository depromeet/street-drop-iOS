//
//  EditCommentUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/09/17.
//

import Foundation

import RxSwift

protocol EditCommentUseCase {
    func edit(itemId: Int, content: String) -> Single<Int>
}
