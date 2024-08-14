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
    private let disposeBag: DisposeBag = .init()
    
    init(searchMusicUsecase: SearchMusicUsecase = DefaultSearchingMusicUsecase()) {
        self.searchMusicUsecase = searchMusicUsecase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        
        fileprivate let showVillageNameRelay: PublishRelay<String> = .init()
        var showVillageName: Observable<String> {
            showVillageNameRelay.asObservable()
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
        
        
        return output
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
