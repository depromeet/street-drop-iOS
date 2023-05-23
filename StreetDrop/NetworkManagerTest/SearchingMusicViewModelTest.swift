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
    private var viewModel: DefaultSearchingMusicViewModel!
    private var viewModelWithEncryptedKeyword: DefaultSearchingMusicViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
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
        self.viewModelWithEncryptedKeyword = nil
    }
    
    func test_searchMusic_success() {
        //given
        let keyword = "방탄소년단"
        
        //then
        viewModel.searchMusic(keyword: keyword)
        
        viewModel.searchedMusicList
            .bind { musicList in
                if musicList.isEmpty {
                    XCTFail()
                } else {
                    XCTAssert(true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    //FIXME: Mock 데이터 활용법을 위한 테스트 코드 (추후 삭제 바람)
    func test_searchMusic_with_encryptedKeyword_success() {
        //given
        let keyword = "방탄소년단"
        
        //then
        viewModelWithEncryptedKeyword.searchMusic(keyword: keyword)
        
        viewModelWithEncryptedKeyword.searchedMusicList
            .bind { musicList in
                if musicList.isEmpty {
                    XCTFail()
                } else {
                    XCTAssert(true)
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension SearchingMusicViewModelTest {
    //FIXME: Mock 데이터 활용법을 위한 Mock 데이터 (추후 삭제 바람)
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
