//
//  MainRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/10.
//

import Foundation

import RxSwift

protocol MainRepository {
    func fetchPoi(lat: Double, lon: Double, distance: Double) -> Single<Pois>
    func fetchMusicCountByDong(lat: Double, lon: Double) -> Single<MusicCountEntity>
    func fetchMusicWithinArea(lat: Double, lon: Double, distance: Double) -> Single<Musics>
}
