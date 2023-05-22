//
//  SearchingMusicViewModelTest.swift
//  NetworkManagerTest
//
//  Created by 차요셉 on 2023/05/19.
//

import XCTest

import RxSwift
import Moya

final class SearchingMusicViewModelTest: XCTestCase {
    var viewModel: SearchingMusicViewModel!
    var viewModelWithEncryptedKeyword: SearchingMusicViewModel!
    
    override func setUpWithError() throws {
        self.viewModel = DefaultSearchingMusicViewModel(
            model: DefaultSearchingMusicModel(
                searchingMusicRepository: DefaultSearchingMusicRepository()
            )
        )
        
        self.viewModelWithEncryptedKeyword = DefaultSearchingMusicViewModel(
            model: DefaultSearchingMusicModel(
                searchingMusicRepository: MockSearchingMusicRepository()
            )
        )
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
    }
    
    func test_searchMusic_success() {
        //given
        let keyword = "방탄소년단"
        
        //then
        viewModel.searchMusic(keyword: keyword)
    }
    
    func test_searchMusic_with_encryptedKeyword_success() {
        //given
        let keyword = "방탄소년단"
        
        //then
        viewModelwithEncryptedKeyword.searchMusic(keyword: keyword)
    }
}

private extension SearchingMusicViewModelTest {
    final class MockSearchingMusicRepository: SearchingMusicRepository {
        private let networkManager: NetworkManager
        
        init(
            networkManager: NetworkManager = NetworkManager(
                provider: MoyaProvider<NetworkService>()
            )
        ) {
            self.networkManager = networkManager
        }
        
        func fetchMusic(keyword: String) -> Single<[SearchedMusicResponseDTO.Music]> {
            //MARK: 암호화된 키워드로 테스트
            let encryptedKeyword = String(keyword.hashValue)
            return networkManager.searchMusic(keyword: encryptedKeyword)
                .map { musicData -> [SearchedMusicResponseDTO.Music] in
                    let searchedMusic = try JSONDecoder().decode(
                        SearchedMusicResponseDTO.self,
                        from: musicData
                    )
                    return searchedMusic.musicList
                }
        }
    }
}
