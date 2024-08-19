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
    
    init(
        searchMusicUsecase: SearchMusicUsecase = DefaultSearchingMusicUsecase(),
        dropMusicUseCase: DropMusicUseCase = DefaultDropMusicUseCase()
    ) {
        self.searchMusicUsecase = searchMusicUsecase
        self.dropMusicUseCase = dropMusicUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let sharedMusicKeyWordEvent: Observable<String>
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
                owner.searchMusicUsecase.searchMusic(keyword: sharedMusicKeyWord)
                    .subscribe(with: self) { owner, musicList in
                        guard let firstMusic = musicList.first else {
                            // TODO: 요셉, 검색된 음악 없다는 이벤트 view에 전달
                            return
                        }
                        owner.output.showSearchedMusicRelay.accept(firstMusic)
                        owner.selectedMusic = firstMusic
                    } onFailure: { owner, error in
                        
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
                    // TODO: 요셉, 선택한 음악정보 없다는 에러팝업
                    return
                }
                
                guard let comment = owner.comment else {
                    // TODO: 코멘트 없다는 에러팝업
                    return
                }
                
                guard let currentLocation = owner.currentLocation else {
                    // TODO: 현재 위치정보 없다는 에러팝업
                    return
                }
                
                owner.dropMusicUseCase.drop(
                    droppingInfo: .init(
                        location: currentLocation,
                        music: selectedMusic
                    ),
                    content: comment
                )
                .subscribe { statusCode in
                    print("성공")
                } onFailure: { error in
                    print(error.localizedDescription)
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
                // TODO: 요셉, 실패 팝업 띄우기
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // TODO: 요셉, 에러메세지 띄우기
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
    }
}
