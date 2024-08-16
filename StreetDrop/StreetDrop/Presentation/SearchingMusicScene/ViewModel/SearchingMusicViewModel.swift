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
    var trendingMusicList: [Music] { get }
    var mostDroppedMusicList: [Music] { get }
    
    func searchMusic(output: Output, keyword: String)
}

final class DefaultSearchingMusicViewModel: SearchingMusicViewModel {
    private let model: SearchMusicUsecase
    private let recommendMusicUseCase: RecommendMusicUsecase
    let location: CLLocation
    var address: String = ""
    private let disposeBag: DisposeBag = DisposeBag()
    private var musicList: [Music] = []
    
    var trendingMusicList: [Music] = []
    var mostDroppedMusicList: [Music] = []
    
    struct Input {
        let viewDidLoadEvent: PublishRelay<Void>
        let searchTextFieldEmptyEvent: Observable<Void>
        let keyBoardDidPressSearchEventWithKeyword: Observable<String>
        let recentQueryDidPressEvent: PublishRelay<String>
        let artistQueryDidPressEvent: PublishRelay<String>
        let musicDidPressEvent: PublishRelay<Music>
        let tableViewCellDidPressedEvent: Observable<Int>
        let deletingButtonTappedEvent: PublishRelay<String>
    }
   
    struct Output {
        let searchedMusicList = PublishRelay<[Music]>()
        let recentMusicQueries = PublishRelay<[String]>()
        let selectedMusic = PublishRelay<Music>()
        let promptOfTheDay = PublishRelay<String>()
        let trendingMusicList = PublishRelay<[Music]>()
        let mostDroppedMusicList = PublishRelay<[Music]>()
        let artists = PublishRelay<[Artist]>()
    }
    
    init(
        model: SearchMusicUsecase = DefaultSearchingMusicUsecase(),
        recommendMusicUseCase: RecommendMusicUsecase = DefaultRecommendMusicUsecase(),
        location: CLLocation
    ) {
        self.model = model
        self.recommendMusicUseCase = recommendMusicUseCase
        self.location = location
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
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
                self?.recommendMusicUseCase.getPromptOfTheDay()
                    .subscribe { result in
                        switch result {
                        case .success(let prompt):
                            output.promptOfTheDay.accept(prompt)
                        case .failure(_):
                            output.mostDroppedMusicList.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
                self?.recommendMusicUseCase.getTrendingMusicList()
                    .subscribe { [weak self] result in
                        switch result {
                        case .success(let musicList):
                            output.trendingMusicList.accept(musicList)
                            self?.trendingMusicList = musicList
                        case .failure(_):
                            output.mostDroppedMusicList.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
                self?.recommendMusicUseCase.getMostDroppedMusicList()
                    .subscribe { result in
                        switch result {
                        case .success(let musicList):
                            output.mostDroppedMusicList.accept(musicList)
                            self?.mostDroppedMusicList = musicList
                        case .failure(_):
                            output.mostDroppedMusicList.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
                self?.recommendMusicUseCase.getArtistList()
                    .subscribe { result in
                        switch result {
                        case .success(let artists):
                            output.artists.accept(artists)
                        case .failure(_):
                            output.artists.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
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
        
        input.artistQueryDidPressEvent
            .bind { [weak self] artistQuery in
                self?.searchMusic(output: output, keyword: artistQuery)
            }
            .disposed(by: disposedBag)
        
        input.tableViewCellDidPressedEvent
            .bind { [weak self] indexPathRow in
                guard let self = self else { return }
                output.selectedMusic.accept(self.musicList[indexPathRow])
            }
            .disposed(by: disposedBag)
        
        input.musicDidPressEvent
            .bind { music in
                output.selectedMusic.accept(music)
            }
            .disposed(by: disposedBag)
        
        input.deletingButtonTappedEvent
            .bind { [weak self] keyword in
                guard let self else { return }
                
                Task {
                    await self.model.deleteRecentSearch(keyword: keyword)
                    
                    do {
                        let recentQueries = try await self.model.getRecentSearches().value
                        output.recentMusicQueries.accept(recentQueries)
                    } catch {
                        output.recentMusicQueries.accept([])
                    }
                }
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
