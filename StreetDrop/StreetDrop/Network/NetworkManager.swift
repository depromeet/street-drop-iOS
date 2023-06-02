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
    var provider = MoyaProvider<NetworkService>()
    let disposeBag = DisposeBag()

    init(provider: MoyaProvider<NetworkService> = MoyaProvider()) {
        self.provider = provider
    }
    
    func searchMusic(keyword: String) -> Single<Data> {
        return provider.rx.request(.searchMusic(keyword: keyword))
            .retry(3)
            .map { $0.data }
    }
    
    func dropMusic(requestDTO: DropMusicRequestDTO) -> Single<Int> {
        return provider.rx.request(.dropMusic(requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }
    
    func fetchNumberOfDroppedMusicByDong(address: String) -> Single<Data> {
        return provider.rx.request(.fetchNumberOfDroppedMusicByDong(address: address))
            .retry(3)
            .map { $0.data }
    }
    
    func getMusicWithinArea(requestDTO: MusicWithinAreaRequestDTO) -> Single<Data> {
        return provider.rx.request(.getMusicWithinArea(requestDTO: requestDTO))
            .retry(3)
            .map { $0.data }
    }
    
    func getCommunity(itemID: UUID) -> Single<Data> {
        return provider.rx.request(.getCommunity(itemID: itemID))
            .retry(3)
            .map { $0.data }
    }

    func getPoi(latitude: Double, longitude: Double, distance: Double) -> Single<Data> {
        return provider.rx
            .request(.getPOI(latitude: latitude, longitude: longitude, distance: distance))
            .retry(3)
            .map { $0.data }
    }
}
