//
//  FetchingLevelPolicyUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2024/04/16.
//

import Foundation

import RxSwift

protocol FetchingLevelPolicyUseCase {
    func fetchLevelPolicy() -> Single<[LevelPolicy]>
}
