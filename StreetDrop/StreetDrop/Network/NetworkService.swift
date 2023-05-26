//
//  NetworkService.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import UIKit

import Moya

enum NetworkService {
    case getWeather(lat: String, lon: String)
    case searchMusic(keyword: String)
    case dropMusic(requestDTO: DropMusicRequestDTO)
    case fetchNumberOfDroppedMusicByDong(address: String)
    case getMusicWithinArea(requestDTO: MusicWithinAreaRequestDTO)
    case getCommunity(itemID: UUID)
    case getPOI(latitude: Double, longitude: Double, distance: Double)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .getWeather:
            return URL(string: "https://api.openweathermap.org")!
        case .dropMusic:
            return URL(string: "https://api.street-drop.com")!
        default:
            return URL(string: "https://search.street-drop.com")!
        }
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
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
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeather, .searchMusic, .fetchNumberOfDroppedMusicByDong, .getPOI:
            return .get
        case .dropMusic:
            return .post
        case .getMusicWithinArea:
            return .get
        case .getCommunity:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getWeather(let lat, let lon):
            return .requestParameters(parameters: ["lat": lat,
                                                   "lon": lon,
                                                   "units": "metric",
                                                   "appid": "a50685674910fa58b68f60c8d0d7835a"],
                                      encoding: URLEncoding.queryString)
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
        case .getWeather:
            return Data("weatherSampleData".utf8)
        case .searchMusic:
            return Data("""
                        {
                            "data": [
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    },
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    },
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    }
                                ]
                        }
                        """.utf8)
        case .dropMusic:
            return Data()
        case .fetchNumberOfDroppedMusicByDong:
            return Data("""
                        {
                            "numberOfDroppedMusic": 247
                        }
                        """.utf8)
        case .getMusicWithinArea:
            return Data()
        case .getCommunity:
            return Data()
        case .getPOI:
            return Data("""
                        {
                            "poi": [
                            {
                                "itemId": 1,
                                "albumThumbnailImage" : "http://img.com",
                                "latitude": 89.33,
                                "longitude": 123.222
                            },
                            {
                                "itemId": 2,
                                "albumThumbnailImage" : "http://img.com",
                                "latitude": 88.214,
                                "longitude": 122.908
                            }
                            ]
                        }
                        """.utf8)
        }
    }
}
