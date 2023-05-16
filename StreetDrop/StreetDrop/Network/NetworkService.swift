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
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case .getWeather:
            return URL(string: "https://api.openweathermap.org")!
        case .searchMusic:
            return URL(string: "search.street-drop.com")!
        }
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeather, .searchMusic:
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
        }
    }
}
