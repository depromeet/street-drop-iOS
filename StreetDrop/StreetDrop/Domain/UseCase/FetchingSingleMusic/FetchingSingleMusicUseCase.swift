//
//  FetchingSingleMusicUseCase.swift
//  StreetDrop
//
//  Created by thoonk on 2023/12/21.
//

import Foundation

import RxSwift

protocol FetchingSingleMusicUseCase {
    func fetchSingleMusic(itemID: Int) -> Single<Musics>
}
