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

protocol SearchingMusicViewModel {
    associatedtype Input
    associatedtype Output
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output
    func searchMusic(keyword: String)
}

final class DefaultSearchingMusicViewModel: SearchingMusicViewModel {
    private let model: SearchingMusicModel
    private let disposeBag: DisposeBag = DisposeBag()
    let searchedMusicList: PublishRelay = PublishRelay<[SearchedMusicResponseDTO.Music]>()
    
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
            .skip(2) // 최초 실행 시, 최초 텍스트 필드 클릭 이벤트 무시
            .bind { [weak self] keyword in
                self?.searchMusic(keyword: keyword)
            }
            .disposed(by: disposedBag)
        
        input.keyBoardDidPressSearchEventWithKeyword
            .bind { keyword in
                self.model.saveRecentSearch(keyword: keyword)
            }
            .disposed(by: disposedBag)
                
        self.searchedMusicList
            .bind(to: output.searchedMusicList)
            .disposed(by: disposedBag)
        
        return output
    }
    
    func searchMusic(keyword: String) {
        if keyword.isEmpty {
            self.searchedMusicList.accept([])
        } else {
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
}

extension DefaultSearchingMusicViewModel {
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let searchTextFieldDidEditEvent: ControlProperty<String>
        let keyBoardDidPressSearchEventWithKeyword: Observable<String>
    }
    
    struct Output {
        let searchedMusicList = PublishRelay<[SearchedMusicResponseDTO.Music]>()
        let recentMusicQueries = BehaviorRelay<[String]>(value: [""])
    }
}
