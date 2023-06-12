//
//  SearchingMusicViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import CoreLocation
import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol SearchingMusicViewModel: ViewModel {
    func searchMusic(output: Output, keyword: String)
}

final class DefaultSearchingMusicViewModel: SearchingMusicViewModel {
    private let model: SearchingMusicModel
    let location: CLLocation
    let address: String
    private let disposeBag: DisposeBag = DisposeBag()
    let searchedMusicList: PublishRelay = PublishRelay<[Music]>()
    private var musicList: [Music] = []
    
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let searchTextFieldDidEditEvent: ControlProperty<String>
        let keyBoardDidPressSearchEventWithKeyword: Observable<String>
        let recentQueryDidPressEvent: PublishRelay<String>
        let tableViewCellDidPressedEvent: Observable<Int>
    }
    
    struct Output {
        let searchedMusicList = PublishRelay<[Music]>()
        let recentMusicQueries = BehaviorRelay<[String]>(value: [""])
        let selectedMusic = PublishRelay<Music>()
    }
    
    init(
        model: SearchingMusicModel = DefaultSearchingMusicModel(),
        location: CLLocation,
        address: String
    ) {
        self.model = model
        self.location = location
        self.address = address
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.model.fetchRecentSearch()
                    .subscribe { result in
                        switch result {
                        case .success(let queries):
                            output.recentMusicQueries.accept(queries)
                        case .failure(_):
                            output.recentMusicQueries.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
            })
            .disposed(by: disposedBag)
        
        input.searchTextFieldDidEditEvent
            .bind { [weak self] keyword in
                // 검색어가 공백일 경우, 뮤직리스트 빈값으로 설정
                if keyword.isEmpty {
                    self?.searchedMusicList.accept([])
                }
            }
            .disposed(by: disposedBag)
        
        input.keyBoardDidPressSearchEventWithKeyword
            .bind { [weak self] keyword in
                if !keyword.isEmpty {
                    self?.searchMusic(output: output, keyword: keyword)
                    self?.model.saveRecentSearch(keyword: keyword)
                }
            }
            .disposed(by: disposedBag)
                
        input.recentQueryDidPressEvent
            .bind { [weak self] recentQuery in
                self?.searchMusic(output: output, keyword: recentQuery)
            }
            .disposed(by: disposedBag)
        
        input.tableViewCellDidPressedEvent
            .bind { [weak self] indexPathRow in
                guard let self = self else { return }
                output.selectedMusic.accept(self.musicList[indexPathRow])
            }
            .disposed(by: disposedBag)
        
        return output
    }
    
    func searchMusic(output: Output, keyword: String) {
        model.fetchMusic(keyword: keyword)
            .subscribe { result in
                switch result {
                case .success(let musicList):
                    output.searchedMusicList.accept(musicList)
                    self.musicList = musicList
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
