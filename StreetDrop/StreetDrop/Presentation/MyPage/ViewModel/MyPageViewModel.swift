//
//  MyPageViewModel.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

final class MyPageViewModel: ViewModel {
    private let model = DefaultMyPageModel(
        repository: DefaultMyPageRepository(
            networkManager: NetworkManager()
        )
    )
}

extension MyPageViewModel {
    struct Input {
        let viewWillAppearEvent: PublishRelay<Void>
    }
    
    struct Output {
        var levelImageURL = PublishRelay<String>()
        var levelName = PublishRelay<String>()
        var nickName = PublishRelay<String>()
        var myDropMusicsSections = PublishRelay<[MyMusicsSection]>()
        var myLikeMusicsSections = PublishRelay<[MyMusicsSection]>()
    }
}

extension MyPageViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
            
        input.viewWillAppearEvent
            .bind {_ in
                self.fetchLevelItems(output: output, disposedBag: disposedBag)
                self.fetchMyDropMusicsSections(output: output, disposedBag: disposedBag)
                self.fetchMyLikeMusicsSections(output: output, disposedBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        return output
    }
    
    func fetchLevelItems(output: Output, disposedBag: DisposeBag) {
        model.fetchMyLevel()
            .subscribe { result in
                switch result {
                case .success(let levelItem):
                    output.levelName.accept(levelItem.levelName)
                    output.levelImageURL.accept(levelItem.levelImageURL)
                    output.nickName.accept(levelItem.nickName)
                case .failure:
                    break
                }
            }
            .disposed(by: disposedBag)
    }
    
    func fetchMyDropMusicsSections(output: Output, disposedBag: DisposeBag) {
        model.fetchMyDropList()
            .subscribe { result in
                switch result {
                case .success(let musics):
                    output.myDropMusicsSections.accept(
                        musics.map {
                            .init(date: $0.date, items: $0.musics)
                        }
                    )
                case .failure(let error):
                    output.myDropMusicsSections.accept([])
                }
            }
            .disposed(by: disposedBag)
    }

    func fetchMyLikeMusicsSections(output: Output, disposedBag: DisposeBag) {
        model.fetchMyLikeList()
            .subscribe { result in
                switch result {
                case .success(let musics):
                    output.myLikeMusicsSections.accept(
                        musics.map {
                            .init(date: $0.date, items: $0.musics)
                        }
                    )
                case .failure:
                    output.myLikeMusicsSections.accept([])
                }
            }
            .disposed(by: disposedBag)
    }
}
