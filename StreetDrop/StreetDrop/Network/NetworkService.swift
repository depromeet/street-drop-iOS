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
    case recommendMusic
    case dropMusic(requestDTO: DropMusicRequestDTO)
    case getSingleMusic(itemID: Int) // 아이템 드랍 - 단건 조회
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
    case patchUsersMusicApp(musicAppQuery: String)
    case myDropList
    case myLikeList
    case myLevel
    case myLevelProgress
    case levelPolicy
    case editNickname(nickname: String)
    case userCircleRadius
    case getPopUpInfomation
    case postPopUpUserReading(requestDTO: PopUpUserReadingRequestDTO)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .searchMusic:
            return URL(string: "https://search.street-drop.com")!
#if DEBUG // 테스트 서버 주소
        default:
            return URL(string: "https://test-api.street-drop.com")!
#elseif RELEASE // 실 서버 주소
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
        case .getSingleMusic(let itemID):
            return "/items/\(itemID)"
        case .searchMusic:
            return "/music"
        case .recommendMusic:
            return "/search-term/recommend"
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
        case .patchUsersMusicApp:
            return "/users/music-app"
        case .myDropList:
            return "/users/me/items/drop"
        case .myLikeList:
            return "/users/me/items/like"
        case .myLevel:
            return "/users/me/level"
        case .myLevelProgress:
            return "/users/me/level/progress"
        case .levelPolicy:
            return "/level/policy"
        case .editNickname:
            return "/users/me/nickname"
        case .userCircleRadius:
            return "/users/me/distance"
        case .getPopUpInfomation:
            return "/pop-up"
        case .postPopUpUserReading:
            return "/pop-up/read"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyInfo,
                .searchMusic,
                .recommendMusic,
                .getMusicCountByDong,
                .getPoi,
                .getMusicWithinArea,
                .getSingleMusic,
                .getCommunity,
                .getVillageName,
                .myDropList,
                .myLikeList,
                .myLevel,
                .myLevelProgress,
                .levelPolicy
                .userCircleRadius,
                .getPopUpInfomation:
            return .get
        case .dropMusic,
                .postLikeUp,
                .postLikeDown,
                .claimComment,
                .blockUser,
                .postFCMToken,
                .postPopUpUserReading:
            return .post
        case .editComment, .patchUsersMusicApp, .editNickname:
            return .patch
        case .deleteMusic:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyInfo, .myDropList, .myLikeList, .myLevel, .myLevelProgress, .levelPolicy, .recommendMusic, .userCircleRadius, .getPopUpInfomation:
            return .requestPlain
        case .searchMusic(let keyword):
            return .requestParameters(
                parameters: ["keyword": keyword],
                encoding: URLEncoding.queryString)
        case .dropMusic(let dropRequestDTO):
            return .requestJSONEncodable(dropRequestDTO)
        case .getSingleMusic(let itemID):
            return .requestParameters(
                parameters: ["itemID": itemID],
                encoding: URLEncoding.queryString
            )
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
            return .requestParameters(
                parameters: ["itemID": itemID],
                encoding: URLEncoding.queryString
            )
        case .postLikeUp(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString
            )
        case .postLikeDown(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString
            )
        case .getPoi(let lat, let lon, let distance):
            return .requestParameters(
                parameters: [
                    "latitude": lat,
                    "longitude": lon,
                    "distance": distance
                ],
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
        case .patchUsersMusicApp(musicAppQuery: let musicAppQuery):
            return .requestParameters(
                parameters: ["musicApp": musicAppQuery],
                encoding: URLEncoding.queryString
            )
        case .editNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        case let .postPopUpUserReading(requestDTO):
            return .requestJSONEncodable(requestDTO)
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
        case .getPopUpInfomation:
            return ResponseSampleData.getPopUpInfomationSampleData
        default:
            return Data()
        }
    }
}
