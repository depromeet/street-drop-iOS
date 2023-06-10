//
//  MainViewModel.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/03.
//

import Foundation


import RxRelay
import RxSwift

final class MainViewModel: ViewModel {
    var lat: Double = 0.0
    var lon: Double = 0.0
    var distance: Double = 1000.0
    var address: String = ""
    
    private let model = MainModel(
        repository: DefaultMainRepository(
            networkManager: NetworkManager()
        )
    )
    private let disposeBag: DisposeBag = DisposeBag()
}


extension MainViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<(Double, Double, String)>
    }

    struct Output {
        var pois = BehaviorRelay<Pois>(value: [])
        var musicCount = BehaviorRelay<Int>(value: 0)
    }
}

extension MainViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let (lat, lon) = ($0.0, $0.1)
                self.lat = lat
                self.lon = lon
                self.model.fetchPois(lat: lat, lon: lon, distance: self.distance)
                    .subscribe { result in
                        switch result {
                        case .success(let pois):
                            output.pois.accept(pois)
                        case .failure(_):
                            output.pois.accept([])
                        }
                    }
                    .disposed(by: disposedBag)
            })
            .disposed(by: disposedBag)
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let address = $0.2
                self.address = address
                self.model.fetchMusicCount(address: address)
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
        
        return output
    }
}
