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
    private let model: SearchMusicUsecase
    let location: CLLocation
    var address: String = ""
    private let disposeBag: DisposeBag = DisposeBag()
    private var musicList: [Music] = []
    
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let searchTextFieldEmptyEvent: Observable<Void>
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
        model: SearchMusicUsecase = DefaultSearchingMusicUsecase(),
        location: CLLocation
    ) {
        self.model = model
        self.location = location
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.model.getRecentSearches()
                    .subscribe { result in
                        switch result {
                        case .success(let queries):
                            output.recentMusicQueries.accept(queries)
                        case .failure(_):
                            output.recentMusicQueries.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
                
                self?.fetchCurrentLocationVillageName()
            })
            .disposed(by: disposedBag)
        
        input.searchTextFieldEmptyEvent
            .bind {
                output.searchedMusicList.accept([])
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
        model.searchMusic(keyword: keyword)
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
    
    func fetchCurrentLocationVillageName() {
        self.model.getVillageName(
            latitude: self.location.coordinate.latitude,
            longitude: self.location.coordinate.longitude
        )
        .subscribe { result in
            switch result {
            case .success(let villageName):
                self.address = villageName
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}
