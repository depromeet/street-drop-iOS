//
//  DropMusicUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/09/17.
//

import Foundation

import RxSwift

protocol DropMusicUseCase {
    func drop(droppingInfo: DroppingInfo, content: String) -> Single<Int>
}
