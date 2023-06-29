//
//  ClaimCommentRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/29.
//

import Foundation

import RxSwift

protocol ClaimCommentRepository {
    func claimComment(itemID: Int, reason: String) -> Single<Int>
}
