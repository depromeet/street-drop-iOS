//
//  ClaimUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol ClaimingCommentUseCase {
    func execute(itemID: Int, reason: String) -> Single<Int>
}
