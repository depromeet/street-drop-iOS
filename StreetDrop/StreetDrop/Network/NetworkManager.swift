//
//  NetworkManager.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import Foundation

import Alamofire
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
        return requestWithCatchingError(token: .getMyInfo)
            .retry(3)
            .map { $0.data }
    }
    
    func searchMusic(keyword: String) -> Single<Data> {
        return requestWithCatchingError(token: .searchMusic(keyword: keyword))
            .retry(3)
            .map { $0.data }
    }
    
    func dropMusic(requestDTO: DropMusicRequestDTO) -> Single<Int> {
        return requestWithCatchingError(token: .dropMusic(requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }
    
    func getMusicCountByDong(latitude: Double, longitude: Double) -> Single<Data> {
        return requestWithCatchingError(token: .getMusicCountByDong(latitude: latitude, longitude: longitude))
            .retry(3)
            .map { $0.data }
    }
    
    func getMusicWithinArea(latitude: Double, longitude: Double, distance: Double) -> Single<Data> {
        return requestWithCatchingError(token: .getMusicWithinArea(latitude: latitude, longitude: longitude, distance: distance))
            .retry(3)
            .map { $0.data }
    }
    
    func getCommunity(itemID: UUID) -> Single<Data> {
        return requestWithCatchingError(token: .getCommunity(itemID: itemID))
            .retry(3)
            .map { $0.data }
    }

    func getPoi(latitude: Double, longitude: Double, distance: Double) -> Single<Data> {
        return requestWithCatchingError(token: .getPoi(latitude: latitude, longitude: longitude, distance: distance))
            .retry(3)
            .map { $0.data }
    }

    func postLikeUp(itemID: Int) -> Single<Int> {
        return requestWithCatchingError(token: .postLikeUp(itemID: itemID))
            .retry(3)
            .map { $0.statusCode }
    }

    func postLikeDown(itemID: Int) -> Single<Int> {
        return requestWithCatchingError(token: .postLikeDown(itemID: itemID))
            .retry(3)
            .map { $0.statusCode }
    }

    func claimComment(requestDTO: ClaimCommentRequestDTO) -> Single<Int> {
        return requestWithCatchingError(token: .claimComment(requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }

    func editComment(itemID: Int, requestDTO: EditCommentRequestDTO) -> Single<Int> {
        return requestWithCatchingError(token: .editComment(itemID: itemID, requestDTO: requestDTO))
            .retry(3)
            .map { $0.statusCode }
    }

    func deleteMusic(itemID: Int) -> Single<Int> {
        return requestWithCatchingError(token: .deleteMusic(itemID: itemID))
            .retry(3)
        .map { $0.statusCode }
    }
    
    func getVillageName(latitude: Double, longitude: Double) -> Single<Data> {
        return requestWithCatchingError(token: .getVillageName(latitude: latitude, longitude: longitude))
            .retry(3)
            .map { $0.data }
    }

    func blockUser(_ blockUserID: Int) -> Single<Int> {
        return requestWithCatchingError(token: .blockUser(blockUserID: blockUserID))
            .retry(3)
            .map { $0.statusCode }
    }
    
    func postFCMToken(token: FCMTokenRequestDTO) -> Single<Int> {
        return requestWithCatchingError(token: .postFCMToken(token: token))
            .retry(3)
            .map { $0.statusCode }
    }
}


// MARK: - Error Handling
private extension NetworkManager {
    func requestWithCatchingError(token: NetworkService) -> Single<Response> {
        return provider.rx.request(token)
            .filterSuccessfulStatusCodes()
            .catch(checkInternetConnection)
            .catch(checkTimeOut)
            .catch(checkRESTError)
    }

    func converToURLError(_ error: Error) -> URLError? {
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
    
    func checkInternetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = converToURLError(error),
              urlError.code == .notConnectedToInternet else {
            throw error
        }
        
        throw NetworkError.notConnectedToInternet
    }
    
    func checkTimeOut<T: Any>(error: Error) throws -> Single<T> {
        guard let urlError = converToURLError(error),
              urlError.code == .timedOut else {
            throw error
        }
        
        throw NetworkError.timeout
    }
    
    func checkRESTError<T: Any>(error: Error) throws -> Single<T> {
        guard error is NetworkError else {
            throw NetworkError.restError(
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String,
                errorMessage: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["message"] as? String
            )
        }
        
        throw error
    }
}
