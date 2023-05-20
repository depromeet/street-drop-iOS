//
//  SearchingMusicRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import RxSwift

protocol SearchingMusicRepository {
    func fetchMusic(keyword: String) -> Single<[SearchedMusicResponseDTO.Music]>
}
