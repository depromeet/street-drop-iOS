//
//  FetchingMyLikeListUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

protocol FetchingMyLikeListUseCase {
    func fetchMyLikeList() -> Single<TotalMyMusics>
}
