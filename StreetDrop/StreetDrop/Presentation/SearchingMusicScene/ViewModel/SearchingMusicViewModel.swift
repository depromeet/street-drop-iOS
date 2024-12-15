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
    private let searchMusicUsecase: SearchMusicUsecase
    private let recommendMusicUseCase: RecommendMusicUsecase
    private let searchPlaceholderUseCase: FetchingSearchPlaceholderUseCase
    let location: CLLocation
    var address: String = ""
    private let disposeBag: DisposeBag = DisposeBag()
    private var musicList: [Music] = []
    private let defaultPrompt = "드랍할 음악 검색"

    struct Input {
        let viewDidLoadEvent: PublishRelay<Void>
        let searchTextFieldEmptyEvent: Observable<Void>
        let keyBoardDidPressSearchEventWithKeyword: Observable<String>
        let recentQueryDidPressEvent: PublishRelay<String>
        let keywordQueryDidPressEvent: PublishRelay<String>
        let musicDidPressEvent: PublishRelay<Music>
        let tableViewCellDidPressedEvent: Observable<Int>
        let deletingButtonTappedEvent: PublishRelay<String>
    }
   
    struct Output {
        let searchedMusicList = PublishRelay<[Music]>()
        let recentMusicQueries = PublishRelay<[String]>()
        let selectedMusic = PublishRelay<Music>()
        let promptOfTheDay = PublishRelay<String>()
        let recommendSections = PublishRelay<[RecommendSectionEntity]>()
        let recommendSectionModels = PublishRelay<[RecommendMusicSectionModel]>()
    }
    
    init(
        searchMusicUsecase: SearchMusicUsecase = DefaultSearchingMusicUsecase(),
        recommendMusicUseCase: RecommendMusicUsecase = DefaultRecommendMusicUsecase(),
        searchPlaceholderUseCase: FetchingSearchPlaceholderUseCase = DefaultFetchingSearchPlaceholderUseCase(),
        location: CLLocation
    ) {
        self.searchMusicUsecase = searchMusicUsecase
        self.recommendMusicUseCase = recommendMusicUseCase
        self.searchPlaceholderUseCase = searchPlaceholderUseCase
        self.location = location
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.searchMusicUsecase.getRecentSearches()
                    .subscribe { result in
                        switch result {
                        case .success(let queries):
                            output.recentMusicQueries.accept(queries)
                        case .failure(_):
                            output.recentMusicQueries.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
                self.fetchCurrentLocationVillageName()

                let prompt = self.searchPlaceholderUseCase.fetchPromptOfTheDay()
                output.promptOfTheDay.accept(prompt ?? self.defaultPrompt)

                self.recommendMusicUseCase.getRecommendSections()
                    .subscribe { result in
                        switch result {
                        case .success(let recommendSections):
                            output.recommendSections.accept(recommendSections)
                            output.recommendSectionModels.accept(
                                recommendSections.compactMap { $0.sectionModel }
                            )
                        case .failure(_):
                            output.recommendSections.accept([])
                            output.recommendSectionModels.accept([])
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
                    self?.searchMusicUsecase.saveRecentSearch(keyword: keyword)
                }
            }
            .disposed(by: disposedBag)
                
        input.recentQueryDidPressEvent
            .bind { [weak self] recentQuery in
                self?.searchMusic(output: output, keyword: recentQuery)
            }
            .disposed(by: disposedBag)
        
        input.keywordQueryDidPressEvent
            .bind { [weak self] keywordQuery in
                self?.searchMusic(output: output, keyword: keywordQuery)
                self?.searchMusicUsecase.saveRecentSearch(keyword: keywordQuery)
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
                    await self.searchMusicUsecase.deleteRecentSearch(keyword: keyword)

                    do {
                        let recentQueries = try await self.searchMusicUsecase.getRecentSearches().value
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
        searchMusicUsecase.searchMusic(keyword: keyword)
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
        self.searchMusicUsecase.getVillageName(
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
