//
//  FetchingMyDropListUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 7/16/24.
//

import Foundation

import RxSwift

protocol FetchingMyDropListUseCase {
    func fetchMyDropList() -> Single<TotalMyMusics>
}
