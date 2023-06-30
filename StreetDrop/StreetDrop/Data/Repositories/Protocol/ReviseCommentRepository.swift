//
//  ReviseCommentRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

import RxSwift

protocol ReviseCommentRepository {
    func reviseComment(itemID: Int, comment: String) -> Single<Int>
}
