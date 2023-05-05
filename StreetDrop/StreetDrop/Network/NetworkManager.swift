//
//  NetworkManager.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import Foundation

import Moya
import RxSwift
import RxMoya

struct NetworkManager {
    let provider = MoyaProvider<NetworkService>()
    let disposeBag = DisposeBag()
    
    func getWeather(lat: String, lon: String) -> Observable<Data?> {
        return provider.rx.request(.getWeather(lat: lat, lon: lon))
            .retry(3)
            .map { response -> Data? in
                return response.data
            }
            .asObservable()
            .catchAndReturn(nil)
    }
}
