//
//  FetchingPOIUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

protocol FetchingPOIUseCase {
    func fetchPois(lat: Double, lon: Double, distance: Double) -> Single<Pois>
}
