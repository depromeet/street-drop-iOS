//
//  LikeMusicRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/11.
//

import Foundation

import RxSwift

protocol LikeMusicRepository {
    func likeUp(itemID: Int) -> Single<Int>
    func likeDown(itemID: Int) -> Single<Int>
}
