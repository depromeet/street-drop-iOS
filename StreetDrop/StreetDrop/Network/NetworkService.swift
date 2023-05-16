//
//  NetworkService.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/05.
//

import Foundation

import Moya

enum NetworkService {
    case getWeather(lat: String, lon: String)
    case searchMusic(keyword: String)
    case dropMusic(requestDTO: DropMusicRequestDTO)
    case fetchNumberOfDroppedMusicByDong(address: String)
    case getMusicWithinArea(requestDTO: MusicWithinAreaRequestDTO)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .getWeather:
            return URL(string: "https://api.openweathermap.org")!
        case .searchMusic, .dropMusic, .fetchNumberOfDroppedMusicByDong, .getMusicWithinArea:
            return URL(string: "search.street-drop.com")!
        }
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
        case .getMusicWithinArea:
            return "/musicWithinArea"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeather, .searchMusic, .fetchNumberOfDroppedMusicByDong:
            return .get
        case .dropMusic:
            return .post
        case .getMusicWithinArea:
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
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
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
                                    "albumImg": "https://is2-ssl.mzstatic.com/image.../.jpg",
                                    "albumThumbnailImg": "https://is2-ssl.mzstatic.com/.../.jpg"
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
        }
    }
}
