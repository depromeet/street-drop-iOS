//
//  MainViewModel.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/03.
//

import Foundation
import CoreLocation

import RxRelay
import RxSwift

final class MainViewModel: ViewModel {
    var location: CLLocation = CLLocation(latitude: 37.4979, longitude: 127.0275)
    var distance: Double = 200000 // 1차 앱스토어 배포 시엔, 대한민국 전체 조회를 위해 반지름 200KM로 조회
    var address: String = ""
    var musicWithinArea: Musics = []
    
    private let model = MainModel(
        repository: DefaultMainRepository(
            networkManager: NetworkManager()
        )
    )
    var locationManager = LocationManager()
    let locationUpdated = PublishRelay<Void>()
    
    init() {
        self.locationManager.delegate = self
    }
}

extension MainViewModel {
    struct Input {
        let locationUpdated: PublishRelay<Void>
        let viewDidLoadEvent: PublishRelay<Void>
        let viewWillAppearEvent: PublishRelay<Void>
    }
    
    struct Output {
        var location = PublishRelay<CLLocation>()
        var address = PublishRelay<String>()
        var pois = PublishRelay<Pois>()
        var musicCount = BehaviorRelay<Int>(value: 0)
        var musicWithinArea = BehaviorRelay<Musics>(value: [])
    }
}

extension MainViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        // TODO: viewDidLoadEvent, viewWillAppearEvent처리 더 괜찮은 RX연산자 있다면 리팩토링!
        input.viewDidLoadEvent
            .sample(self.locationUpdated) // 앱 실행 시, 두 이벤트 모두 들어올 경우 한번만 fetchPois
            .take(1)
            .bind {_ in
                self.model.fetchPois(
                    lat: self.location.coordinate.latitude,
                    lon: self.location.coordinate.longitude,
                    distance: self.distance
                )
                .subscribe { result in
                    switch result {
                    case .success(let pois):
                        output.pois.accept(pois)
                    case .failure:
                        output.pois.accept([])
                    }
                }
                .disposed(by: disposedBag)
            }
            .disposed(by: disposedBag)
            
        input.viewWillAppearEvent // ViewWillAppear 시, fetchPois
            .skip(1) // 첫 ViewWillAppear땐 CLLocation 가져오지 못해 스킵
            .bind {_ in
                self.model.fetchPois(
                    lat: self.location.coordinate.latitude,
                    lon: self.location.coordinate.longitude,
                    distance: self.distance
                )
                .subscribe { result in
                    switch result {
                    case .success(let pois):
                        output.pois.accept(pois)
                    case .failure:
                        output.pois.accept([])
                    }
                }
                .disposed(by: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                output.location.accept(self.location)
            })
            .disposed(by: disposedBag)

        // 서나가 고친곳✅✅✅✅✅
//        input.locationUpdated
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                let latitude = self.location.coordinate.latitude
//                let longitude = self.location.coordinate.longitude
//
//                self.model.fetchMusicCount(lat: latitude, lon: longitude)
//                    .subscribe { result in
//                        switch result {
//                        case .success(let musicCountEntity):
//                            output.musicCount.accept(musicCountEntity.musicCount)
//                            output.address.accept(musicCountEntity.address)
//                        case .failure(_):
//                            output.musicCount.accept(0)
//                        }
//                    }
//                    .disposed(by: disposedBag)
//            })
//            .disposed(by: disposedBag)
        return output
    }
}


extension MainViewModel: LocationManagerDelegate {
    func updateLocation(location: CLLocation) {
        self.location = location
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location, preferredLocale: nil) { (placemarks, error) in
//            guard let address = placemarks?.first else { return }
//            // 차후 서버 포맷에 맞게 수정 필요
////             self.address = address.name ?? ""
//            self.address = "종로구 사직동"
            self.locationUpdated.accept(())
    }
}
