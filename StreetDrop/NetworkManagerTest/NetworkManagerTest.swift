//
//  NetworkManagerTest.swift
//  NetworkManagerTest
//
//  Created by 맹선아 on 2023/05/06.
//

import XCTest

import Moya

final class NetworkManagerTest: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let moyaProvider = MoyaProvider<NetworkService>(stubClosure: MoyaProvider.immediatelyStub)
        sut = NetworkManager(provider: moyaProvider)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_getWeather_success() {
        //given
        let (sampleLat, sampleLon) = ("300", "300")

        //then
        var response: Data?
        sut.getWeather(lat: sampleLat, lon: sampleLon)
            .subscribe(onNext: { data in
                if let data = data {
                    response = data
                }
            })
            .dispose()

        XCTAssertNotEqual(response, Data("wrongSampleData".utf8))
        XCTAssertEqual(response, Data("weatherSampleData".utf8))
    }

    func test_fetchPOI_success() {
        //given
        let (latitude, longitude, zoomLevel) = (123.123, 32.234, 3)

        //then: 첫번째 데이터의 poi 위도는 89.33이다
        var response: Data?

        sut.fetchPOI(latitude: latitude, longitude: longitude, zoomLevel: zoomLevel)
            .subscribe {  data in
                response = data
            }
            .dispose()

        do {
            let allPoi = try JSONDecoder().decode(Poi.self, from: response ?? Data()).allPOI
            XCTAssertNotEqual(10.12, allPoi[0].latitude)
            XCTAssertEqual(89.33, allPoi[0].latitude)
        } catch {
            XCTFail("Decoding Error")
        }
    }
}
