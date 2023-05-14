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
    case fetchPOI(latitude: Double, longitude: Double, zoomLevel: Int)
}

extension NetworkService: TargetType {
    var baseURL: URL { return URL(string: "https://api.openweathermap.org")! }
    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
        case .fetchPOI:
            return "Sample"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather:
            return .get
        case .fetchPOI:
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
        case .fetchPOI:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getWeather:
            return ["Content-type": "application/json"]
        default:
            return nil
        }
    }

    var sampleData: Data {
        switch self {
        case .getWeather:
            return Data("weatherSampleData".utf8)
        case .fetchPOI:
            return Data("""
                    {
                      "poi": [
                        {
                          "itemId": 1,
                          "albumCover" : "http://img.com",
                          "latitude": 89.33,
                          "longitude": 123.222
                        },
                        {
                          "itemId": 2,
                          "albumCover" : "http://img.com",
                          "latitude": 88.214,
                          "longitude": 122.908
                        }
                      ]
                    }
                    """.utf8)
        }
    }
}
