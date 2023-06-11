//
//  NetworkService.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import UIKit

import Moya

enum NetworkService {
    case searchMusic(keyword: String)
    case dropMusic(requestDTO: DropMusicRequestDTO)
    case fetchNumberOfDroppedMusicByDong(address: String)
    case getMusicWithinArea(requestDTO: MusicWithinAreaRequestDTO)
    case getCommunity(itemID: UUID)
    case getPOI(latitude: Double, longitude: Double, distance: Double)
    case postLikeUp(itemID: UUID)
    case postLikeDown(itemID: UUID)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .dropMusic, .postLikeUp, .postLikeDown:
            return URL(string: "https://api.street-drop.com")!
        default:
            return URL(string: "https://search.street-drop.com")!
        }
    }

    var path: String {
        switch self {
        case .getMusicWithinArea:
            return "/musicWithinArea"
        case .getCommunity:
            return "/community"
        case .dropMusic:
            return "/items"
        case .searchMusic:
            return "/music"
        case .fetchNumberOfDroppedMusicByDong:
            return "/villages/items/count"
        case .postLikeUp(let itemID):
            return "/items/\(itemID)/likes"
        case .postLikeDown(let itemID):
            return "/items/\(itemID)/unlikes"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchMusic,
             .fetchNumberOfDroppedMusicByDong,
             .getPOI,
             .getMusicWithinArea,
             .getCommunity:
            return .get
        case .dropMusic,
             .postLikeUp,
             .postLikeDown:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .searchMusic(let keyword):
            return .requestParameters(
                parameters: ["keyword": keyword],
                encoding: URLEncoding.queryString)
        case .dropMusic(let dropRequestDTO):
            return .requestJSONEncodable(dropRequestDTO)
        case .fetchNumberOfDroppedMusicByDong(let address):
            return .requestParameters(
                parameters: ["address": address],
                encoding: URLEncoding.queryString
            )
        case .getMusicWithinArea(let musicWithinAreaRequestDTO):
            return .requestJSONEncodable(musicWithinAreaRequestDTO)
        case .getCommunity(let itemID):
            return .requestParameters(parameters: ["itemID": itemID],
                                      encoding: URLEncoding.queryString)
        case .getPOI:
            return .requestPlain // API주소 확정 후 수정예정
        case .postLikeUp(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString)
        case .postLikeDown(let itemID):
            return .requestParameters(
                parameters: ["itemId": itemID],
                encoding: URLEncoding.queryString)
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
        case .fetchNumberOfDroppedMusicByDong:
            return ResponseSampleData.fetchNumberOfDroppedMusicByDongSampleData
        case .getPOI:
            return ResponseSampleData.getPOISampleData
        default:
            return Data()
        }
    }
}
