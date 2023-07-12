//
//  NetworkService.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import UIKit

import Moya

enum NetworkService {
    case getMyInfo
    case searchMusic(keyword: String)
    case dropMusic(requestDTO: DropMusicRequestDTO)
    case getMusicCountByDong(latitude: Double, longitude: Double)
    case getMusicWithinArea(latitude: Double, longitude: Double, distance: Double)
    case getCommunity(itemID: UUID)
    case postLikeUp(itemID: Int)
    case postLikeDown(itemID: Int)
    case getPoi(latitude: Double, longitude: Double, distance: Double)
    case claimComment(requestDTO: ClaimCommentRequestDTO)
    case editComment(itemID: Int, requestDTO: EditCommentRequestDTO)
    case deleteMusic(itemID: Int)
    case getVillageName(latitude: Double, longitude: Double)
    case blockUser(blockUserID: Int)
    case postFCMToken(token: FCMTokenRequestDTO)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
#if DEBUG // 테스트 서버 주소
        case .searchMusic:
            return URL(string: "https://test-search.street-drop.com")!
        default:
            return URL(string: "https://test-api.street-drop.com")!
#elseif RELEASE // 실 서버 주소
        case .searchMusic:
            return URL(string: "https://search.street-drop.com")!
        default:
            return URL(string: "https://api.street-drop.com")!
#endif
        }
    }
    
    var path: String {
        switch self {
        case .getMyInfo:
            return "users/me"
        case .getMusicWithinArea:
            return "/items"
        case .getCommunity:
            return "/community"
        case .dropMusic:
            return "/items"
        case .searchMusic:
            return "/music"
        case .getMusicCountByDong:
            return "/villages/items/count"
        case .postLikeUp(let itemID):
            return "/items/\(itemID)/likes"
        case .postLikeDown(let itemID):
            return "/items/\(itemID)/unlikes"
        case .getPoi:
            return "/items/points"
        case .claimComment:
            return "/items/claim"
        case .editComment(let itemID, _):
            return "/items/\(itemID)"
        case .deleteMusic(let itemID):
            return "/items/\(itemID)"
        case .getVillageName:
            return "/geo/reverse-geocode"
        case .blockUser:
            return "/users/block"
        case .postFCMToken:
            return "/notifications/tokens"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyInfo,
                .searchMusic,
                .getMusicCountByDong,
                .getPoi,
                .getMusicWithinArea,
                .getCommunity,
                .getVillageName:
            return .get
        case .dropMusic,
                .postLikeUp,
                .postLikeDown,
                .claimComment,
                .blockUser:
                .postFCMToken:
            return .post
        case .editComment:
            return .patch
        case .deleteMusic:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyInfo:
            return .requestPlain
        case .searchMusic(let keyword):
            return .requestParameters(
                parameters: ["keyword": keyword],
                encoding: URLEncoding.queryString)
        case .dropMusic(let dropRequestDTO):
            return .requestJSONEncodable(dropRequestDTO)
        case .getMusicCountByDong(let latitude, let longitude):
            return .requestParameters(
                parameters: [
                    "latitude": String(latitude),
                    "longitude": String(longitude)
                ],
                encoding: URLEncoding.queryString
            )
        case .getMusicWithinArea(let lat, let lon, let distance):
            return .requestParameters(
                parameters: ["latitude": lat,
                             "longitude": lon,
                             "distance": distance],
                encoding: URLEncoding.queryString
            )
        case .getCommunity(let itemID):
            return .requestParameters(parameters: ["itemID": itemID],
                                      encoding: URLEncoding.queryString)
        case .postLikeUp(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString)
        case .postLikeDown(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString)
        case .getPoi(let lat, let lon, let distance):
            return .requestParameters(
                parameters: ["latitude": lat,
                             "longitude": lon,
                             "distance": distance],
                encoding: URLEncoding.queryString
            )
        case .claimComment(let claimCommentRequestDTO):
            return .requestJSONEncodable(claimCommentRequestDTO)
        case .editComment(_, let editCommentRequestDTO):
            return .requestJSONEncodable(editCommentRequestDTO)
        case .deleteMusic(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString
            )
        case .getVillageName(let latitude, let longitude):
            return .requestParameters(
                parameters: [
                    "latitude": String(latitude),
                    "longitude": String(longitude)
                ],
                encoding: URLEncoding.queryString
            )
        case .blockUser(let blockUserID):
            return .requestParameters(
                parameters: ["blockUserID": blockUserID],
                encoding: URLEncoding.queryString
            )
        case .postFCMToken(token: let token):
            return .requestJSONEncodable(token)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "x-sdp-idfv": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
    }
    
    var sampleData: Data {
        switch self {
        case .searchMusic:
            return ResponseSampleData.searchMusicSampleData
        case .getMusicCountByDong:
            return ResponseSampleData.fetchNumberOfDroppedMusicByDongSampleData
        case .getPoi:
            return ResponseSampleData.getPOISampleData
        default:
            return Data()
        }
    }
}
