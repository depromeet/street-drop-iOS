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
    private let fetchingMyLevelUseCase: FetchingMyLevelUseCase
    private let fetchingLevelPolicyUseCase: FetchingLevelPolicyUseCase
    private let fetchingMyDropListUseCase: FetchingMyDropListUseCase
    private let fetchingMyLikeListUseCase: FetchingMyLikeListUseCase
    private let fetchingSingleMusicUseCase: FetchingSingleMusicUseCase
    
    private var myMusicType: MyMusicType = .drop
    
    init(
        fetchingMyLevelUseCase: FetchingMyLevelUseCase = DefaultFetchingMyLevelUseCase(),
        fetchingLevelPolicyUseCase: FetchingLevelPolicyUseCase = DefaultFetchingLevelPolicyUseCase(),
        fetchingMyDropListUseCase: FetchingMyDropListUseCase = DefaultFetchingMyDropListUseCase(),
        fetchingMyLikeListUseCase: FetchingMyLikeListUseCase = DefaultFetchingMyLikeListUseCase(),
        fetchingSingleMusicUseCase: FetchingSingleMusicUseCase = DefaultFetchingSingleMusicUseCase()
    ) {
        self.fetchingMyLevelUseCase = fetchingMyLevelUseCase
        self.fetchingLevelPolicyUseCase = fetchingLevelPolicyUseCase
        self.fetchingMyDropListUseCase = fetchingMyDropListUseCase
        self.fetchingMyLikeListUseCase = fetchingMyLikeListUseCase
        self.fetchingSingleMusicUseCase = fetchingSingleMusicUseCase
    }
}

extension MyPageViewModel: ViewModel {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let listTypeTapEvent: Observable<MyMusicType>
        let levelPolicyTapEvent: Observable<Void>
        let selectedMusicEvent: Observable<Int>
    }
    
    struct Output {
        let levelImageURL = PublishRelay<String>()
        let levelName = PublishRelay<String>()
        let nickName = PublishRelay<String>()
        let myMusicsSections = PublishRelay<[MyMusicsSectionType]>()
        let totalMusicsCount = PublishRelay<Int>()
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
        let lastestListType =  PublishRelay<MyMusicType>()
            
        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                owner.fetchLevelItems(output: output, disposedBag: disposedBag)
                owner.fetchLevelProgress(output: output, disposeBag: disposedBag)
                
                lastestListType.accept(owner.myMusicType)
            }
            .disposed(by: disposedBag)
        
        input.listTypeTapEvent
            .bind(to: lastestListType)
            .disposed(by: disposedBag)
        
        lastestListType
            .bind(with: self) { owner, type in
                owner.myMusicType = type
                
                switch type {
                case .drop:
                    owner.fetchMyDropMusicsSections(output: output, disposedBag: disposedBag)
                case .like:
                    owner.fetchMyLikeMusicsSections(output: output, disposedBag: disposedBag)
                }
            }
            .disposed(by: disposedBag)
        
        input.levelPolicyTapEvent
            .bind(with: self) { owner, _ in
                owner.fetchLevelPolicy(output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.selectedMusicEvent
            .bind(with: self) { owner, itemID in
                owner.fetchMyDropMusic(
                    itemID: itemID,
                    output: output,
                    disposedBag: disposedBag
                )
            }
            .disposed(by: disposedBag)
        
        return output
    }
}

// MARK: - Private Methods

private extension MyPageViewModel {
    func fetchLevelItems(output: Output, disposedBag: DisposeBag) {
        fetchingMyLevelUseCase.fetchMyLevel()
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
        fetchingMyLevelUseCase.fetchMyLevelProgress()
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
        fetchingLevelPolicyUseCase.fetchLevelPolicy()
            .subscribe(with: self, onSuccess: { owner, levelPolicies in
                output.levelPoliciesRelay.accept(levelPolicies)
            }, onFailure: { _, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMyDropMusicsSections(
        output: Output,
        disposedBag: DisposeBag
    ) {
        fetchingMyDropListUseCase.fetchMyDropList()
            .subscribe(with: self, onSuccess: { owner, totalMusics in
                output.totalMusicsCount.accept(totalMusics.totalCount)
                let myMusicsSections = owner.convertToSectionTypes(from: totalMusics)
                output.myMusicsSections.accept(myMusicsSections)
            }, onFailure: { _, error in
                print("❌Fetching My Drop List Error: \(error.localizedDescription)")
                output.toast.accept("네트워크를 확인해 주세요")
            })
            .disposed(by: disposedBag)
    }
    
    func fetchMyLikeMusicsSections(output: Output, disposedBag: DisposeBag) {
        fetchingMyLikeListUseCase.fetchMyLikeList()
            .subscribe(with: self, onSuccess: { owner, totalMusics in
                output.totalMusicsCount.accept(totalMusics.totalCount)
                let myMusicsSections = owner.convertToSectionTypes(from: totalMusics)
                output.myMusicsSections.accept(myMusicsSections)
            }, onFailure: { _, error in
                print("❌Fetching My Like List Error: \(error.localizedDescription)")
                output.toast.accept("네트워크를 확인해 주세요")
            })
            .disposed(by: disposedBag)
    }
    
    func fetchMyDropMusic(
        itemID: Int,
        output: Output,
        disposedBag: DisposeBag
    ) {
        fetchingSingleMusicUseCase.fetchSingleMusic(itemID: itemID)
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
    
    func convertToSectionTypes(from totalMusics: TotalMyMusics) -> [MyMusicsSectionType] {
        return totalMusics.musics.map { myMusics in
            MyMusicsSectionType(
                section: .musics(date: myMusics.date),
                items: myMusics.musics
            )
        }
    }
}
