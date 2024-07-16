//
//  FetchingMyLevelUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

protocol FetchingMyLevelUseCase {
    func fetchMyLevel() -> Single<MyLevel>
    func fetchMyLevelProgress() -> Single<MyLevelProgress>
}
