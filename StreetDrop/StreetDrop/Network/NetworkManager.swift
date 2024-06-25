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
    private let provider: MoyaProvider<MultiTarget>
    
    init(
        provider: MoyaProvider<MultiTarget> = .init()
    ) {
        self.provider = provider
    }
    
    func request<U: Decodable>(target: MultiTarget, responseType: U.Type) -> Single<U> {
        return provider.rx.request(target)
            .retry(3)
            .filterSuccessfulStatusCodes()
            .map(U.self)
    }
    
    func requestStatusCode(target: MultiTarget) -> Single<Int> {
        return provider.rx.request(target)
            .map { $0.statusCode }
    }
}
