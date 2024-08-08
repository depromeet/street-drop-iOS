//
//  MyPageRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift
import OrderedCollections

protocol MyPageRepository {
    func fetchMyDropList() -> Single<TotalMyMusics>
    func fetchMyLikeList() -> Single<TotalMyMusics>
    func fetchMyLevel() -> Single<MyLevel>
    func fetchMyLevelProgress() -> Single<MyLevelProgress>
    func fetchLevelPolicy() -> Single<[LevelPolicy]>
    func fetchMyDropMusic(itemID: Int) -> Single<Musics>
    func fetchCityAndDistricts() throws -> OrderedDictionary<String, [String]>
}
