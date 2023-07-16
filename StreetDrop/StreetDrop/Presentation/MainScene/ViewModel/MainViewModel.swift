//
//  MainViewModel.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/03.
//

import Foundation
import CoreLocation

import NMapsMap
import RxCocoa
import RxRelay
import RxSwift

final class MainViewModel: ViewModel {
    var location: CLLocation = CLLocation()
    var poisDistance: Double = 200000 // 1차 앱스토어 배포 시엔, 대한민국 전체 조회를 위해 반지름 200KM로 조회
    var detailItemsDistance: Double = 500
    var currentLocationAddress: String = ""
    var musicWithinArea: Musics = []
    var currentIndex: Int = 0
    var tappedPOIID: Int?
    private var poiMarkers: [NMFMarker] = []
    
    private let model = MainModel(
        repository: DefaultMainRepository(
            networkManager: NetworkManager()
        )
    )
    var locationManager = LocationManager()
    private let locationUpdated = PublishRelay<Void>()
    
    init() {
        self.locationManager.delegate = self
    }
}

extension MainViewModel {
    struct Input {
        let viewDidLoadEvent: PublishRelay<Void>
        let viewWillAppearEvent: PublishRelay<Void>
        let poiMarkerDidTapEvent: PublishRelay<Int>
        let cameraDidStopEvent: PublishRelay<(latitude: Double, longitude: Double)>
        let homeButtonDidTapEvent: ControlEvent<Void>
        let myLocationButtonDidTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        var location = PublishRelay<CLLocation>()
        var cameraAddress = PublishRelay<String>()
        var pois = PublishRelay<Pois>()
        var musicCount = BehaviorRelay<Int>(value: 0)
        var musicWithinArea = BehaviorRelay<Musics>(value: [])
        var cameraShouldGoCurrentLocation = PublishRelay<CLLocation>()
        var tappedPOIIndex = PublishRelay<Int>()
    }
}

extension MainViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        // TODO: viewDidLoadEvent, viewWillAppearEvent처리 더 괜찮은 RX연산자 있다면 리팩토링!
        input.viewDidLoadEvent
            .sample(self.locationUpdated) // 앱 실행 시, 두 이벤트 모두 들어올 경우 한번만 fetchPois
            .take(1)
            .bind { [weak self] in
                guard let self = self else { return }
                self.fetchPois(output: output, disposedBag: disposedBag)
                self.fetchMusicCount(
                    latitude: self.location.coordinate.latitude,
                    longitude: self.location.coordinate.longitude,
                    output: output,
                    disposedBag: disposedBag
                )
                output.cameraShouldGoCurrentLocation.accept(self.location)
                self.fetchMusicWithArea(output: output, disposedBag: disposedBag)
                self.fetchMyInfoAndSave(disposedBag: disposedBag)
            }
            .disposed(by: disposedBag)
            
        input.viewWillAppearEvent // ViewWillAppear 시, fetchPois
            .skip(1) // 첫 ViewWillAppear땐 CLLocation 가져오지 못해 스킵
            .bind {_ in
                self.fetchPois(output: output, disposedBag: disposedBag)
                self.fetchMusicCount(
                    latitude: self.location.coordinate.latitude,
                    longitude: self.location.coordinate.longitude,
                    output: output,
                    disposedBag: disposedBag
                )
            }
            .disposed(by: disposedBag)
        
        input.cameraDidStopEvent
            .skip(1)
            .bind { (latitude: Double, longitude: Double) in
                self.fetchMusicCount(
                    latitude: latitude,
                    longitude: longitude,
                    output: output,
                    disposedBag: disposedBag
                )
            }
            .disposed(by: disposedBag)
        
        self.locationUpdated
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                output.location.accept(self.location)
            })
            .disposed(by: disposedBag)
        
        input.poiMarkerDidTapEvent
            .do(onNext: { poiID in
                self.tappedPOIID = poiID
            })
            .withLatestFrom(self.locationUpdated)
            .bind { [weak self] in
                guard let self = self else { return }
                self.fetchMusicWithArea(output: output, disposedBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.homeButtonDidTapEvent
            .bind { [weak self] in
                self?.locationManager.startUpdatingLocation()
            }
            .disposed(by: disposedBag)
        
        input.myLocationButtonDidTapEvent
            .bind {
                output.cameraShouldGoCurrentLocation.accept(self.location)
            }
            .disposed(by: disposedBag)
        
        return output
    }
    
    func isWithin(latitude: Double, longitude: Double) -> Bool {
        let radius: Double = 500
        let distanceFromCurrentLocation: Double = location.distance(
            from: CLLocation(
                latitude: latitude,
                longitude: longitude
            )
        )
        
        return distanceFromCurrentLocation <= radius
    }
    
    func addPOIMarker(_ poi: NMFMarker) {
        self.poiMarkers.append(poi)
    }
    
    func removeAllPOIMarkers() {
        self.poiMarkers.forEach { $0.mapView = nil }
        self.poiMarkers = []
    }
}

private extension MainViewModel {
    func fetchMyInfoAndSave(disposedBag: DisposeBag) {
        self.model.fetchMyInfo()
            .subscribe { [weak self] myInfo in
                self?.model.saveMyInfo(myInfo)
            }
            .disposed(by: disposedBag)
    }

    func fetchMusicWithArea(output: Output, disposedBag: DisposeBag) {
        self.model.fetchMusicWithinArea(
            lat: self.location.coordinate.latitude,
            lon: self.location.coordinate.longitude,
            distance: self.detailItemsDistance
        )
        .subscribe { result in
            switch result {
            case .success(let musicWithinArea):
                let musicWithinArea = musicWithinArea.sorted { $0.id < $1.id }
                if musicWithinArea.isEmpty {
                    self.musicWithinArea = []
                    output.musicWithinArea.accept([])
                    return
                }
                
                guard let index = musicWithinArea.enumerated().filter({ $0.element.id == self.tappedPOIID}).first?.offset else { return }
                
                if musicWithinArea.count < 4 {
                    self.musicWithinArea = musicWithinArea
                }
                else {
                    // 무한스크롤을 위한 데이터소스
                    var musicWithinAreaForInfinite = musicWithinArea
                    musicWithinAreaForInfinite.insert(musicWithinAreaForInfinite[musicWithinAreaForInfinite.count-1], at: 0)
                    musicWithinAreaForInfinite.insert(musicWithinAreaForInfinite[musicWithinAreaForInfinite.count-2], at: 0)
                    musicWithinAreaForInfinite.append(musicWithinAreaForInfinite[2])
                    musicWithinAreaForInfinite.append(musicWithinAreaForInfinite[3])
                    self.musicWithinArea = musicWithinAreaForInfinite
                }
                output.musicWithinArea.accept(self.musicWithinArea)
                output.tappedPOIIndex.accept(index)
            case .failure(let error):
                print(error)
                output.musicWithinArea.accept([])
            }
        }
        .disposed(by: disposedBag)
    }
    
    func fetchPois(output: Output, disposedBag: DisposeBag) {
        self.model.fetchPois(
            lat: self.location.coordinate.latitude,
            lon: self.location.coordinate.longitude,
            distance: self.poisDistance
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
    
    func fetchMusicCount(
        latitude: Double,
        longitude: Double,
        output: Output,
        disposedBag: DisposeBag
    ) {
        self.model.fetchMusicCount(lat: latitude, lon: longitude)
            .subscribe { result in
                switch result {
                case .success(let musicCountEntity):
                    output.musicCount.accept(musicCountEntity.musicCount)
                    output.cameraAddress.accept(musicCountEntity.villageName)
                case .failure(_):
                    output.musicCount.accept(0)
                }
            }
            .disposed(by: disposedBag)
    }
}

extension MainViewModel: LocationManagerDelegate {
    func updateLocation(location: CLLocation) {
        self.location = location
        self.locationUpdated.accept(())
    }
}
