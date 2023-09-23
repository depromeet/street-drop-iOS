//
//  BlockUserUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol BlockUserUseCase {
    func execute(_ blockUserID: Int) -> Single<Int>
}
