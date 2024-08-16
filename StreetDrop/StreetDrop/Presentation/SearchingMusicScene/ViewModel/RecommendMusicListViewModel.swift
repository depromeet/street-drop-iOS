//
//  DefaultRecommendMusicListViewModel.swift
//  StreetDrop
//
//  Created by jihye kim on 15/08/2024.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

protocol RecommendMusicListViewModel: ViewModel { }

final class DefaultRecommendMusicListViewModel: RecommendMusicListViewModel {
    private let model: RecommendMusicUsecase
    private let disposeBag: DisposeBag = DisposeBag()
    
    let title: String
    let musicList: [Music]
    let location: CLLocation
    let address: String
    
    struct Input {
        let musicDidPressEvent: Observable<Int>
    }
   
    struct Output {
        let musicList = PublishRelay<[Music]>()
        let selectedMusic = PublishRelay<Music>()
    }
    
    init(
        model: RecommendMusicUsecase = DefaultRecommendMusicUsecase(),
        title: String,
        musicList: [Music],
        location: CLLocation,
        address: String
    ) {
        self.model = model
        self.title = title
        self.musicList = musicList
        self.location = location
        self.address = address
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.musicDidPressEvent
            .bind { [weak self] indexPathRow in
                guard let self,
                      let music = self.musicList[safe: indexPathRow]
                else { return }
                output.selectedMusic.accept(music)
            }
            .disposed(by: disposedBag)
        
        return output
    }
}
