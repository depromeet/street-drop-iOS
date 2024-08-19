//
//  RecommendMusicRepository.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import RxSwift

protocol RecommendMusicRepository {
    func fetchPromptOfTheDay() -> Single<String>
    func fetchTrendingMusicList() -> Single<[Music]>
    func fetchMostDroppedMusicList() -> Single<[Music]>
    func fetchArtistList() -> Single<[Artist]>
}
