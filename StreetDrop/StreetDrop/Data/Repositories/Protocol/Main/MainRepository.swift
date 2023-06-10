//
//  MainRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/10.
//

import Foundation

import RxSwift

protocol MainRepository {
    func fetchPoi(lat: Double, lon: Double, distacne: Double) -> Single<Pois>
    func fetchMusicCountByDong(address: String) -> Single<MusicCountEntity>
}
