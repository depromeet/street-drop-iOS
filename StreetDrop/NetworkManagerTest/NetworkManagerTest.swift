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

    func test_searchMusic_success() {
        //given
        let keyword = "dynamite"

        //then 첫번째 데이터의 artistName이 "방탄소년단"
        var response: Data?

        sut.searchMusic(keyword: keyword)
            .subscribe { result in
                switch result {
                case .success(let data):
                    response = data
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .dispose()

        do {
            let searchedMusic = try JSONDecoder().decode(
                SearchedMusicResponseDTO.self,
                from: response ?? Data()
            )
            let musicList = searchedMusic.musicList

            XCTAssertNotEqual("빅뱅", musicList[0].artistName)
            XCTAssertEqual("방탄소년단", musicList[0].artistName)
        } catch {
            XCTFail("Decoding Error")
        }
    }
    
    func test_dropMusic_success() {
        //given
        let droppingLocation = DropMusicRequestDTO.Location(
            latitude: 37.35959299999998,
            longitude: 127.10531600000002,
            address: "성남시 분당구 정자1동"
        )
        
        let droppingMusic = DropMusicRequestDTO.Music(
            title: "하입보이",
            artist: "뉴진스",
            albumName: "NewJeans 1st EP 'New Jeans'",
            albumImage: "https://is2-ssl.mzstatic.com/image.../.jpg",
            genre: [
                "댄스"
            ]
        )
        //then 드랍 API 성공 시, success Result로 들어옴
        sut.dropMusic(
            requestDTO: DropMusicRequestDTO(
                location: droppingLocation,
                music: droppingMusic,
                content: ""
            )
        )
        .subscribe {
            switch $0 {
            case .success(_):
                XCTAssert(true)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        .dispose()
    }
    
    func test_fetchNumberOfDroppedMusicByDong_success() {
        //given
        let address: String = "성남시 분당구 정자1동"
        
        //then 동별 드랍된 음악 갯수가 247이면 성공
        var response: Data?
        
        sut.fetchNumberOfDroppedMusicByDong(address: address)
            .subscribe {
                switch $0 {
                case .success(let data):
                    response = data
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .dispose()
        do {
            let numberOfDroppedMusicByDong = try JSONDecoder().decode(
                NumberOfDroppedMusicByDongResponseDTO.self,
                from: response ?? Data()
            )

            XCTAssertEqual(247, numberOfDroppedMusicByDong.numberOfDroppedMusic)
        } catch {
            XCTFail("Decoding Error")
        }
    }
        
    
    func test_getMusicWithinArea_success() {
        //given
        let sampleRequestDTO = MusicWithinAreaRequestDTO.init(latitude: 30.33, longitude: 30.33, orderBy: "date")
        
        //then
        sut.getMusicWithinArea(requestDTO: sampleRequestDTO)
            .subscribe {
                switch $0 {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .dispose()
    }
    
    func test_getCommunity_success() {
        //given
        let sampleItemId = UUID()
        
        //then
        sut.getCommunity(itemID: sampleItemId)
            .subscribe {
                switch $0 {
                case .success(_):
                    XCTAssert(true)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .dispose()
    }

    func test_getPOI_success() {
        //given
        let (latitude, longitude, zoomLevel) = (123.123, 32.234, 3)

        //then: 첫번째 데이터의 poi 위도는 89.33이면 성공
        var response: Data?

        sut.getPoi(latitude: latitude, longitude: longitude, zoomLevel: zoomLevel)
            .subscribe { result in
                switch result {
                case .success(let data):
                    response = data
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            .dispose()

        do {
            let poiResponse = try JSONDecoder().decode(
                PoiResponseDTO.self,
                from: response ?? Data()
            )
            let pois = poiResponse.pois

            XCTAssertNotEqual(10.12, pois[0].latitude)
            XCTAssertEqual(89.33, pois[0].latitude)
        } catch {
            XCTFail("Decoding Error")
        }
    }
}
