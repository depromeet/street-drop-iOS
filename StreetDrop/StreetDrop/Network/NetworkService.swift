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
    case getMusicCountByDong(address: String)
    case getMusicWithinArea(requestDTO: MusicWithinAreaRequestDTO)
    case getCommunity(itemID: UUID)
    case postLikeUp(itemID: Int)
    case postLikeDown(itemID: Int)
    case getPoi(latitude: Double, longitude: Double, distance: Double)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .searchMusic:
            return URL(string: "https://search.street-drop.com")!
        default:
            return URL(string: "https://api.street-drop.com")!
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
        case .getMusicCountByDong:
            return "/villages/items/count"
        case .postLikeUp(let itemID):
            return "/items/\(itemID)/likes"
        case .postLikeDown(let itemID):
            return "/items/\(itemID)/unlikes"
        case .getPoi:
            return "/items/points"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchMusic,
                .getMusicCountByDong,
                .getPoi,
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
        case .getMusicCountByDong(let address):
            return .requestParameters(
                parameters: ["name": address],
                encoding: URLEncoding.queryString
            )
        case .getMusicWithinArea(let musicWithinAreaRequestDTO):
            return .requestJSONEncodable(musicWithinAreaRequestDTO)
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
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
            //             ,"x-sdp-idfv": UIDevice.current.identifierForVendor?.uuidString ?? ""
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
