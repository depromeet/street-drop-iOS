//
//  RegionFilteringModalViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 7/31/24.
//

import Foundation

import RxSwift
import RxRelay
import OrderedCollections

final class RegionFilteringModalViewModel: ViewModel {
    private let output: Output = .init()
    private let fetchingCityAndDistrictsUseCase: FetchingCityAndDistrictsUseCase
    private var cityAndDistricts: OrderedDictionary<String, [String]> = [:]
    private let fetchingRegionFilteredDropCountUseCase: FetchingRegionFilteredDropCountUseCase
    
    init(
        fetchingCityAndDistrictsUseCase: FetchingCityAndDistrictsUseCase = DefaultFetchingCityAndDistrictsUseCase(),
        fetchingRegionFilteredDropCountUseCase: FetchingRegionFilteredDropCountUseCase = DefualtFetchingRegionFilteredDropCountUseCase()
    ) {
        self.fetchingCityAndDistrictsUseCase = fetchingCityAndDistrictsUseCase
        self.fetchingRegionFilteredDropCountUseCase = fetchingRegionFilteredDropCountUseCase
        do {
            cityAndDistricts = try fetchingCityAndDistrictsUseCase.execute()
        } catch {
            output.errorAlertShowRelay.accept(error.localizedDescription)
        }
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let cityCellClickEvent: Observable<String>
    }
    
    struct Output {
        fileprivate let errorAlertShowRelay: PublishRelay<String> = .init()
        var errorAlertShow: Observable<String> {
            errorAlertShowRelay.asObservable()
        }
        
        fileprivate let cityNamesRelay: BehaviorRelay<[String]> = .init(value: [])
        var cityNames: Observable<[String]> {
            cityNamesRelay.asObservable()
        }
        
        fileprivate let guNamesRelay: BehaviorRelay<[String]> = .init(value: [])
        var guNames: Observable<[String]> {
            guNamesRelay.asObservable()
        }
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .bind(with: self) { owner, _ in
                let cityNames = owner.cityAndDistricts.keys.map { String($0) }
                owner.output.cityNamesRelay.accept(cityNames)
            }
            .disposed(by: disposedBag)
        
        input.cityCellClickEvent
            .bind(with: self) { owner, clickedCity in
                guard let guNames = owner.cityAndDistricts[clickedCity] else { return }
                owner.output.guNamesRelay.accept(guNames)
            }
            .disposed(by: disposedBag)
        
        return output
    }
}
