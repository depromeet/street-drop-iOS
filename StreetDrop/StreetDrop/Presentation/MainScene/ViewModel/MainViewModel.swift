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
    var distance: Double = 1000.0
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
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
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
            })
            .disposed(by: disposedBag)
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                output.location.accept(self.location)
            })
            .disposed(by: disposedBag)
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.model.fetchMusicCount(address: self.address)
                    .subscribe { result in
                        switch result {
                        case .success(let musicCountEntity):
                            output.musicCount.accept(musicCountEntity.musicCount)
                        case .failure(_):
                            output.musicCount.accept(0)
                        }
                    }
                    .disposed(by: disposedBag)
            })
            .disposed(by: disposedBag)
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                output.address.accept(self.address)
            })
            .disposed(by: disposedBag)
        
        input.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.model.fetchMusicWithinArea(
                    lat: self.location.coordinate.latitude,
                    lon: self.location.coordinate.longitude,
                    distance: self.distance
                )
                .subscribe { result in
                    switch result {
                    case .success(let musicWithinArea):
                        if musicWithinArea.isEmpty {
                            self.musicWithinArea = []
                            output.musicWithinArea.accept([])
                            return
                        }
                        // 무한스크롤을 위한 데이터소스
                        var musicWithinAreaForInfinite = musicWithinArea
                        musicWithinAreaForInfinite.insert(musicWithinAreaForInfinite[musicWithinAreaForInfinite.count-1], at: 0)
                        musicWithinAreaForInfinite.insert(musicWithinAreaForInfinite[musicWithinAreaForInfinite.count-2], at: 0)
                        musicWithinAreaForInfinite.append(musicWithinAreaForInfinite[2])
                        musicWithinAreaForInfinite.append(musicWithinAreaForInfinite[3])

                        self.musicWithinArea = musicWithinAreaForInfinite
                        output.musicWithinArea.accept(musicWithinAreaForInfinite)
                    case .failure(let error):
                        print(error)
                        output.musicWithinArea.accept([])
                    }
                }
                .disposed(by: disposedBag)
            })
            .disposed(by: disposedBag)
        
        return output
    }
}

extension MainViewModel: LocationManagerDelegate {
    func updateLocation(location: CLLocation) {
        self.location = location
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: nil) { (placemarks, error) in
            guard let address = placemarks?.first else { return }
            // 차후 서버 포맷에 맞게 수정 필요
//             self.address = address.name ?? ""
            self.address = "종로구 사직동"
            self.locationUpdated.accept(())
        }
    }
}
