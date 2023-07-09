//
//  BlockUserRepository.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/09.
//

import Foundation

import RxSwift

protocol BlockUserRepository {
    func blockUser(_ blockUserID: Int) -> Single<Int>
}
