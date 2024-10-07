//
//  ShareViewModel.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/12/24.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

protocol ShareViewModelType {
    associatedtype Input
    associatedtype Output
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output
}

final class ShareViewModel: NSObject, ShareViewModelType {
    private let output: Output = .init()
    private let locationManger: CLLocationManager = .init()
    private let searchMusicUsecase: SearchMusicUsecase
    private let dropMusicUseCase: DropMusicUseCase
    private let disposeBag: DisposeBag = .init()
    private var currentLocation: DroppingInfo.Location?
    var sharedSongName: String = ""
    var selectedMusic: Music?
    var comment: String?
    var itemID: Int?
    
    init(
        searchMusicUsecase: SearchMusicUsecase = DefaultSearchingMusicUsecase(),
        dropMusicUseCase: DropMusicUseCase = DefaultDropMusicUseCase()
    ) {
        self.searchMusicUsecase = searchMusicUsecase
        self.dropMusicUseCase = dropMusicUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let sharedMusicKeyWordEvent: Observable<String?>
        let changingMusicViewClickEvent: Observable<Void>
        let reSearchingEvent: Observable<String>
        let dropButtonClickEvent: Observable<Void>
    }
    
    struct Output {
        fileprivate let showVillageNameRelay: PublishRelay<String> = .init()
        var showVillageName: Observable<String> {
            showVillageNameRelay.asObservable()
        }
        fileprivate let showSearchedMusicRelay: PublishRelay<Music> = .init()
        var showSearchedMusic: Observable<Music> {
            showSearchedMusicRelay.asObservable()
        }
        fileprivate let showReSearchedMusicListRelay: PublishRelay<[Music]> = .init()
        var showReSearchedMusicList: Observable<[Music]> {
            showReSearchedMusicListRelay.asObservable()
        }
        fileprivate let goDropDoneViewRelay: PublishRelay<(Music, String, String)> = .init()
        var goDropDoneView: Observable<(Music, String, String)> {
            goDropDoneViewRelay.asObservable()
        }
        fileprivate let goFailedLoadingMusicViewRelay: PublishRelay<Void> = .init()
        var goFailedLoadingMusicView: Observable<Void> {
            goFailedLoadingMusicViewRelay.asObservable()
        }
        fileprivate let errorAlertShowRelay: PublishRelay<String> = .init()
        var errorAlertShow: Observable<String> {
            errorAlertShowRelay.asObservable()
        }
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .bind(with: self) { owner, _ in
                owner.locationManger.delegate = self
                owner.locationManger.requestWhenInUseAuthorization()
                owner.locationManger.startUpdatingLocation()
            }
            .disposed(by: disposedBag)
        
        input.sharedMusicKeyWordEvent
            .bind(with: self) { owner, sharedMusicKeyWord in
                guard let sharedMusicKeyWord = sharedMusicKeyWord else {
                    owner.output.goFailedLoadingMusicViewRelay.accept(Void())
                    return
                }
                owner.searchMusicUsecase.searchMusic(keyword: sharedMusicKeyWord)
                    .subscribe(with: self) { owner, musicList in
                        guard let firstMusic = musicList.first else {
                            owner.output.goFailedLoadingMusicViewRelay.accept(Void())
                            return
                        }
                        owner.output.showSearchedMusicRelay.accept(firstMusic)
                        owner.selectedMusic = firstMusic
                    }
                    .disposed(by: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.changingMusicViewClickEvent
            .bind(with: self) { owner, _ in
                owner.reSearchMusic(keyword: owner.sharedSongName, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.reSearchingEvent
            .bind(with: self) { owner, reSearchingKeyword in
                owner.reSearchMusic(keyword: reSearchingKeyword, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.dropButtonClickEvent
            .bind(with: self) { owner, _ in
                guard let selectedMusic = owner.selectedMusic else {
                    owner.output.errorAlertShowRelay.accept("선택한 음악 정보가 없습니다.")
                    return
                }
                
                guard let comment = owner.comment else {
                    owner.output.errorAlertShowRelay.accept("코멘트가 없습니다.")
                    return
                }
                
                guard let currentLocation = owner.currentLocation else {
                    owner.output.errorAlertShowRelay.accept("현재 위치정보가 없습니다.")
                    return
                }
                
                owner.dropMusicUseCase.dropMusicResponsingOnlyItemID(
                    droppingInfo: .init(
                        location: currentLocation,
                        music: selectedMusic
                    ),
                    content: comment
                )
                .subscribe(with: self) { owner, itemID in
                    owner.itemID = itemID
                    owner.output.goDropDoneViewRelay.accept(
                        (selectedMusic, currentLocation.address, comment)
                    )
                } onFailure: { owner, error in
                    owner.output.errorAlertShowRelay.accept("드랍에 실패 했습니다.")
                }
                .disposed(by: disposedBag)

            }
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension ShareViewModel {
    func reSearchMusic(keyword: String, disposeBag: DisposeBag) {
        searchMusicUsecase.searchMusic(keyword: keyword)
            .subscribe(with: self) { owner, musicList in
                owner.output.showReSearchedMusicListRelay.accept(musicList)
            } onFailure: { owner, error in
                owner.output.showReSearchedMusicListRelay.accept([])
            }
            .disposed(by: disposeBag)
    }
}

extension ShareViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        searchMusicUsecase.getVillageName(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        .subscribe(with: self) { owner, villageName in
            owner.output.showVillageNameRelay.accept(villageName)
            owner.currentLocation = .init(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                address: villageName
            )
        } onFailure: { owner, error in
            print(error.localizedDescription)
        }
        .disposed(by: disposeBag)

        manager.stopUpdatingLocation()
    }
}
