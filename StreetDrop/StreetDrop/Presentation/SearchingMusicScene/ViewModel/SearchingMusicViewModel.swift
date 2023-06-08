//
//  SearchingMusicViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol SearchingMusicViewModel: ViewModel {
    func searchMusic(keyword: String)
}

final class DefaultSearchingMusicViewModel: SearchingMusicViewModel {
    private let model: SearchingMusicModel
    private let disposeBag: DisposeBag = DisposeBag()
    let searchedMusicList: PublishRelay = PublishRelay<[Music]>()
    
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let searchTextFieldDidEditEvent: ControlProperty<String>
        let keyBoardDidPressSearchEventWithKeyword: Observable<String>
    }
    
    struct Output {
        let searchedMusicList = PublishRelay<[Music]>()
        let recentMusicQueries = BehaviorRelay<[String]>(value: [""])
    }
    
    init(model: SearchingMusicModel = DefaultSearchingMusicModel()) {
        self.model = model
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
                    self?.searchMusic(keyword: keyword)
                    self?.model.saveRecentSearch(keyword: keyword)
                }
            }
            .disposed(by: disposedBag)
                
        self.searchedMusicList
            .bind(to: output.searchedMusicList)
            .disposed(by: disposedBag)
        
        return output
    }
    
    func searchMusic(keyword: String) {
        model.fetchMusic(keyword: keyword)
            .subscribe { result in
                switch result {
                case .success(let musicList):
                    self.searchedMusicList.accept(musicList)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
