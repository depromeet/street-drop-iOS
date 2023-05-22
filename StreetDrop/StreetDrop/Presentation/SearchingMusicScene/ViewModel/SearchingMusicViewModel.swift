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
    private let searchedMusicList: PublishRelay = PublishRelay<[SearchedMusicResponseDTO.Music]>()
    
    init(model: SearchingMusicModel = DefaultSearchingMusicModel()) {
        self.model = model
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent
            .subscribe(onNext: {
                print("SearchingMusicViewController ViewDidLoad됨")
            })
            .disposed(by: disposedBag)
        
        input.searchTextFieldDidEditEvent
            .filter({ $0 != "" })
            .bind { [weak self] keyword in
                self?.searchMusic(keyword: keyword)
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

extension DefaultSearchingMusicViewModel {
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let searchTextFieldDidEditEvent: ControlProperty<String>
    }
    
    struct Output {
        let searchedMusicList = PublishRelay<[SearchedMusicResponseDTO.Music]>()
    }
}
