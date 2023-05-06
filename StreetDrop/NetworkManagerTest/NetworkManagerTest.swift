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
}
