//
//  MyInfoUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol MyInfoUseCase {
    func fetchMyInfo() -> Single<MyInfo>
    func saveMyInfo(_ myInfo: MyInfo) -> Single<Void>
}
