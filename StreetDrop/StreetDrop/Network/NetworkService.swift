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
}

extension NetworkService: TargetType {
    var baseURL: URL { return URL(string: "https://api.openweathermap.org")! }
    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather:
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
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
