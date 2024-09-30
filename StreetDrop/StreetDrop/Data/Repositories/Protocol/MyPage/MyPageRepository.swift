//
//  MyPageRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxSwift

protocol MyPageRepository {
    func fetchMyDropList(filterType: FilterType) -> Single<TotalMyMusics>
    func fetchMyLikeList(filterType: FilterType) -> Single<TotalMyMusics>
    func fetchMyLevel() -> Single<MyLevel>
    func fetchMyLevelProgress() -> Single<MyLevelProgress>
    func fetchLevelPolicy() -> Single<[LevelPolicy]>
    func fetchMyDropMusic(itemID: Int) -> Single<Musics>
}
