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

final class MyPageViewModel {
    private let model = DefaultMyPageModel(
        repository: DefaultMyPageRepository(
            networkManager: NetworkManager()
        )
    )
    
    var myDropMusicList: [[MyMusic]] = []
    var myLikeMusicList: [[MyMusic]] = []
}

extension MyPageViewModel: ViewModel {
    struct Input {
        let viewWillAppearEvent: PublishRelay<Void>
        let levelPolicyTapEvent: PublishRelay<Void>
        let selectedMusicEvent: PublishRelay<MusicInfo>
    }
    
    struct Output {
        let levelImageURL = PublishRelay<String>()
        let levelName = PublishRelay<String>()
        let nickName = PublishRelay<String>()
        let myDropMusicsSections = PublishRelay<[MyMusicsSection]>()
        let myLikeMusicsSections = PublishRelay<[MyMusicsSection]>()
        let totalDropMusicsCount = PublishRelay<Int>()
        let totalLikeMusicsCount = PublishRelay<Int>()
        let pushCommunityView = PublishRelay<Musics>()
        let toast = PublishRelay<String>()
        let isShowingLevelUpView = PublishRelay<Bool>()
        let remainCountToLevelUp = PublishRelay<Int>()
        let currentDropStateCount = PublishRelay<CurrentDropState>()
        let tipText = PublishRelay<String>()
        fileprivate let levelPoliciesRelay = PublishRelay<[LevelPolicy]>()
        var levelPolicies: Observable<[LevelPolicy]> {
            levelPoliciesRelay.asObservable()
        }
    }
    
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
            
        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                owner.fetchLevelItems(output: output, disposedBag: disposedBag)
                owner.fetchLevelProgress(output: output, disposeBag: disposedBag)
                owner.fetchMyDropMusicsSections(output: output, disposedBag: disposedBag)
                owner.fetchMyLikeMusicsSections(output: output, disposedBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.levelPolicyTapEvent
            .bind(with: self) { owner, _ in
                owner.fetchLevelPolicy(output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.selectedMusicEvent
            .bind(with: self) { owner, musicInfo in
                owner.fetchMyDropMusic(
                    itemID: musicInfo.itemID,
                    output: output,
                    disposedBag: disposedBag
                )
            }
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension MyPageViewModel {
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
    
    func fetchLevelProgress(output: Output, disposeBag: DisposeBag) {
        model.fetchMyLevelProgress()
            .subscribe(with: self, onSuccess: { owner, progress in
                output.isShowingLevelUpView.accept(progress.isShow)
                output.remainCountToLevelUp.accept(progress.remainCount)
                let currentDropState = (progress.dropCount, progress.levelUpCount)
                output.currentDropStateCount.accept(currentDropState)
                output.tipText.accept(progress.tip)
            }, onFailure: { _, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchLevelPolicy(output: Output, disposeBag: DisposeBag) {
        model.fetchLevelPolicy()
            .subscribe(with: self, onSuccess: { owner, levelPolicies in
                output.levelPoliciesRelay.accept(levelPolicies)
            }, onFailure: { _, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMyDropMusicsSections(output: Output, disposedBag: DisposeBag) {
        model.fetchMyDropList()
            .subscribe(with: self, onSuccess: { owner, totalMusics in
                output.totalDropMusicsCount.accept(totalMusics.totalCount)
                output.myDropMusicsSections.accept(
                    totalMusics.musics.map {
                        .init(date: $0.date, items: $0.musics)
                    }
                )
                
                owner.myDropMusicList = totalMusics.musics.map { $0.musics }
            }, onFailure: { _, _ in
                output.myDropMusicsSections.accept([])
            })
            .disposed(by: disposedBag)
    }
    
    func fetchMyLikeMusicsSections(output: Output, disposedBag: DisposeBag) {
        model.fetchMyLikeList()
            .subscribe(with: self, onSuccess: { owner, totalMusics in
                output.totalLikeMusicsCount.accept(totalMusics.totalCount)
                output.myLikeMusicsSections.accept(
                    totalMusics.musics.map {
                        .init(date: $0.date, items: $0.musics)
                    }
                )
                
                owner.myLikeMusicList = totalMusics.musics.map { $0.musics }
            }, onFailure: { _, _ in
                output.myLikeMusicsSections.accept([])
            })
            .disposed(by: disposedBag)
    }
    
    func fetchMyDropMusic(
        itemID: Int,
        output: Output,
        disposedBag: DisposeBag
    ) {
        model.fetchMyDropMusic(itemID: itemID)
            .subscribe(onSuccess: { musics in
                if musics.isEmpty == false {
                    output.pushCommunityView.accept(musics)
                } else {
                    output.toast.accept("네트워크를 확인해 주세요")
                }
            }, onFailure: { error in
                debugPrint(error.localizedDescription)
                output.toast.accept("네트워크를 확인해 주세요")
            })
            .disposed(by: disposedBag)
    }
}
