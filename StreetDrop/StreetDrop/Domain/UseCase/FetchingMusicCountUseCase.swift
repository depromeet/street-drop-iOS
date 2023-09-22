//
//  FetchingMusicCountUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol FetchingMusicCountUseCase {
    func execute(lat: Double, lon: Double) -> Single<MusicCountEntity>
}
