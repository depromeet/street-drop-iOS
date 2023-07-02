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

    func getMyInfo() -> Single<Data> {
        return provider.rx.request(.getMyInfo)
            .retry(3)
            .map { $0.data }
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
    
    func getMusicCountByDong(latitude: Double, longitude: Double) -> Single<Data> {
        return provider.rx
            .request(.getMusicCountByDong(latitude: latitude, longitude: longitude))
            .retry(3)
            .map { $0.data }
    }
    
    func getMusicWithinArea(latitude: Double, longitude: Double, distance: Double) -> Single<Data> {
        return provider.rx
            .request(.getMusicWithinArea(latitude: latitude, longitude: longitude, distance: distance))
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
            .request(.getPoi(latitude: latitude, longitude: longitude, distance: distance))
            .retry(3)
            .map { $0.data }
    }

    func postLikeUp(itemID: Int) -> Single<Int> {
        return provider.rx.request(.postLikeUp(itemID: itemID))
            .retry(3)
            .map { $0.statusCode }
    }

    func postLikeDown(itemID: Int) -> Single<Int> {
        return provider.rx.request(.postLikeDown(itemID: itemID))
            .retry(3)
            .map { $0.statusCode }
    }

    func claimComment(requestDTO: ClaimCommentRequestDTO) -> Single<Int> {
        return provider.rx.request(.claimComment(requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }

    func editComment(itemID: Int, requestDTO: EditCommentRequestDTO) -> Single<Int> {
        return provider.rx.request(.editComment(itemID: itemID, requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }

    func deleteMusic(itemID: Int) -> Single<Int> {
        return provider.rx.request(.deleteMusic(itemID: itemID))
            .retry(3)
            .map { $0.statusCode }
    }
}
