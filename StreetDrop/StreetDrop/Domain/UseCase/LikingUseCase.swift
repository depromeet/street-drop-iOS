//
//  LikeUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol LikingUseCase {
    func likeUp(itemID: Int) -> Single<Int>
    func likeDown(itemID: Int) -> Single<Int>
}
