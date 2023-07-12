//
//  FCMRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/12.
//

import Foundation

import RxSwift

protocol FCMRepository {
    func enrollFCMToken(token: String) -> Single<Int>
}
