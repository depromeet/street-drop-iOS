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
    var poisDistance: Double = 600000 // 1차 앱스토어 배포 시엔, 대한민국 전체 조회를 위해 반지름 200KM로 조회
    let userCircleRadius: Double
    var currentLocationAddress: String = ""
    var musicWithinArea: Musics = []
    var currentIndex: Int = 0
    var tappedPOIID: Int?
    var tappedPOIMarekr: NMFMarker?
    var poiDict: [Int: NMFMarker] = [:] // POI ID로 마커를 찾기 위함입니다.
    private var poiMarkers: [NMFMarker] = []
    var markerAlbumImages: [Int: UIImage] = [:] // POI ID로 앨범 이미지를 찾기 위함입니다.
    private var popUpInfomations: [PopUpInfomation] = []
    private let output = Output()
    
    private let myInfoUseCase: MyInfoUseCase
    private let fetchingPOIUseCase: FetchingPOIUseCase
    private let fetchingMusicCountUseCse: FetchingMusicCountUseCase
    private let fetchingMusicWithinAreaUseCase: FetchingMusicWithinAreaUseCase
    private let fetchingPopUpInfomationUseCase: FetchingPopUpInfomationUseCase
    private let postingPopUpUserReadingUseCase: PostingPopUpUserReadingUseCase
    
    var locationManager = LocationManager()
    private let locationUpdated = PublishRelay<Void>()
    
    init(
        userCircleRadius: Double,
        myInfoUseCase: MyInfoUseCase = DefaultMyInfoUseCase(),
        fetchingPOIUseCase: FetchingPOIUseCase = DefaultFetchingPOIUseCase(),
        fetchingMusicCountUseCse: FetchingMusicCountUseCase = DefaultFetchingMusicCountUseCase(),
        fetchingMusicWithinAreaUseCase: FetchingMusicWithinAreaUseCase = DefaultFetchingMusicWithinAreaUseCase(),
        fetchingSingleMusicUseCase: FetchingSingleMusicUseCase = DefaultFetchingSingleMusicUseCase(),
        fetchingPopUpInfomationUseCase: FetchingPopUpInfomationUseCase = DefaultFetchingPopUpInfomationUseCase(),
        postingPopUpUserReadingUseCase: PostingPopUpUserReadingUseCase = DefaultPostingPopUpUserReadingUseCase()
    ) {
        self.userCircleRadius = userCircleRadius
        self.myInfoUseCase = myInfoUseCase
        self.fetchingPOIUseCase = fetchingPOIUseCase
        self.fetchingMusicCountUseCse = fetchingMusicCountUseCse
        self.fetchingMusicWithinAreaUseCase = fetchingMusicWithinAreaUseCase
        self.fetchingPopUpInfomationUseCase = fetchingPopUpInfomationUseCase
        self.postingPopUpUserReadingUseCase = postingPopUpUserReadingUseCase
        self.locationManager.delegate = self
    }
}

extension MainViewModel {
    struct Input {
        let viewDidLoadEvent: PublishRelay<Void>
        let viewWillAppearEvent: PublishRelay<Void>
        let viewDidAppearEvent: Observable<Void>
        let poiMarkerDidTapEvent: PublishRelay<NMFMarker>
        let cameraDidStopEvent: PublishRelay<(latitude: Double, longitude: Double)>
        let homeButtonDidTapEvent: ControlEvent<Void>
        let myLocationButtonDidTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let location = PublishRelay<CLLocation>()
        let cameraAddress = PublishRelay<String>()
        let pois = PublishRelay<Pois>()
        let musicCount = BehaviorRelay<Int>(value: 0)
        let musicWithinArea = BehaviorRelay<Musics>(value: [])
        let cameraShouldGoCurrentLocation = PublishRelay<CLLocation>()
        let tappedPOIIndex = PublishRelay<Int>()
        let showFirstComment = PublishRelay<Void>()
        let presentSharedMusicView = PublishRelay<Int>()
        
        let tipPopUpShowRelay: PublishRelay<PopUpInfomation> = .init()
        var tipPopUpShow: Observable<PopUpInfomation> {
            tipPopUpShowRelay.asObservable()
        }
        
        let congratulationsLevelUpPopUpShowRelay: PublishRelay<PopUpInfomation> = .init()
        var congratulationsLevelUpPopUpShow: Observable<PopUpInfomation> {
            congratulationsLevelUpPopUpShowRelay.asObservable()
        }
    }
}

extension MainViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        // TODO: viewDidLoadEvent, viewWillAppearEvent처리 더 괜찮은 RX연산자 있다면 리팩토링!
        input.viewDidLoadEvent
            .sample(self.locationUpdated) // 앱 실행 시, 두 이벤트 모두 들어올 경우 한번만 fetchPois
            .take(1)
            .bind(with: self) { owner, _ in
                owner.fetchPois(output: owner.output, disposedBag: disposedBag)
                owner.fetchMusicCount(
                    latitude: self.location.coordinate.latitude,
                    longitude: self.location.coordinate.longitude,
                    output: owner.output,
                    disposedBag: disposedBag
                )
                owner.output.cameraShouldGoCurrentLocation.accept(self.location)
                owner.fetchMusicWithArea(output: owner.output, disposedBag: disposedBag)
                owner.fetchMyInfoAndSave(disposedBag: disposedBag)
                owner.checkAppFirstLaunched(output: owner.output)
                owner.checkUniversialLinkRemained(output: owner.output)
            }
            .disposed(by: disposedBag)
        
//        input.viewDidAppearEvent
//            .bind(with: self) { owner, _ in
//                owner.fetchingPopUpInfomationUseCase.execute()
//                    .subscribe(with: self) { owner, popUpInfomations in
//                        owner.popUpInfomations = popUpInfomations
//                        owner.showFirstPopUpInfomation()
//                    } onFailure: { _, error in
//                        print(error.localizedDescription)
//                    }
//                    .disposed(by: disposedBag)
//
//            }
//            .disposed(by: disposedBag)
        
        input.viewWillAppearEvent // ViewWillAppear 시, fetchPois
            .skip(1) // 첫 ViewWillAppear땐 CLLocation 가져오지 못해 스킵
            .bind(with: self) { owner, _ in
                owner.fetchPois(output: owner.output, disposedBag: disposedBag)
                owner.fetchMusicCount(
                    latitude: self.location.coordinate.latitude,
                    longitude: self.location.coordinate.longitude,
                    output: owner.output,
                    disposedBag: disposedBag
                )
            }
            .disposed(by: disposedBag)
        
        input.cameraDidStopEvent
            .skip(1)
            .bind(with: self) { owner, element in
                self.fetchMusicCount(
                    latitude: element.latitude,
                    longitude: element.longitude,
                    output: owner.output,
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
            .do(onNext: { poiMarker in
                self.tappedPOIMarekr = poiMarker
                self.tappedPOIID = Int(poiMarker.tag)
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
            .bind(with: self) { owner, _  in
                owner.output.cameraShouldGoCurrentLocation.accept(self.location)
            }
            .disposed(by: disposedBag)
        
        return output
    }
    
    func isWithin(latitude: Double, longitude: Double) -> Bool {
        let distanceFromCurrentLocation: Double = location.distance(
            from: CLLocation(
                latitude: latitude,
                longitude: longitude
            )
        )
        
        return distanceFromCurrentLocation <= userCircleRadius
    }
    
    func addPOIMarker(_ poi: NMFMarker) {
        self.poiMarkers.append(poi)
    }
    
    func removeAllPOIMarkers() {
        self.poiMarkers.forEach { $0.mapView = nil }
        self.poiMarkers = []
    }
    
    func postPopUpUserReading(popUpInfomation: PopUpInfomation, disposeBag: DisposeBag) {
        showFirstPopUpInfomation()
        
        postingPopUpUserReadingUseCase.execute(type: popUpInfomation.type, id: popUpInfomation.contentID)
            .subscribe(with: self) { owner, _ in
                print("post Popup User Reading 성공")
            } onFailure: { _, error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

private extension MainViewModel {
    func fetchMyInfoAndSave(disposedBag: DisposeBag) {
        myInfoUseCase.fetchMyInfo()
            .subscribe { [weak self] myInfo in
                self?.myInfoUseCase.saveMyInfo(myInfo)
                    .subscribe(onSuccess: {
                        print("MyInfo 저장 성공")
                    }, onFailure: { error in
                        print(error.localizedDescription)
                    })
                    .disposed(by: disposedBag)
            }
            .disposed(by: disposedBag)
    }

    func fetchMusicWithArea(output: Output, disposedBag: DisposeBag) {
        fetchingMusicWithinAreaUseCase.execute(
            lat: self.location.coordinate.latitude,
            lon: self.location.coordinate.longitude,
            distance: userCircleRadius
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
        fetchingPOIUseCase.execute(
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
        fetchingMusicCountUseCse.execute(lat: latitude, lon: longitude)
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
    
    func checkAppFirstLaunched(output: Output) {
        let isLaunchedBefore = myInfoUseCase.checkLaunchedBefore()
        if isLaunchedBefore == false {
            output.showFirstComment.accept(Void())
        }
    }
    
    func checkUniversialLinkRemained(output: Output) {
        let itemID = UserDefaults.standard.integer(forKey: UserDefaultKey.sharedMusicItemID)
        
        if itemID > 0 {
            output.presentSharedMusicView.accept(itemID)
        }
    }
    
    func showFirstPopUpInfomation() {
        if let firstPopUpInfomation = popUpInfomations.first {
            switch firstPopUpInfomation.type {
            case "guide":
                output.tipPopUpShowRelay.accept(firstPopUpInfomation)
            case "levelUp":
                output.congratulationsLevelUpPopUpShowRelay.accept(firstPopUpInfomation)
            default:
                break
            }
            popUpInfomations.removeFirst()
        }
    }
}

extension MainViewModel: LocationManagerDelegate {
    func updateLocation(location: CLLocation) {
        self.location = location
        self.locationUpdated.accept(())
    }
}
