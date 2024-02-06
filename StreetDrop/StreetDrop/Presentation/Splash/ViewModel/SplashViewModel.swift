//
//  SplashViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2/6/24.
//

import Foundation

import RxRelay
import RxSwift

final class SplashViewModel: ViewModel {
    private let output: Output = .init()
    private let fetchingUserCircleRadiusUsecase: FetchingUserCircleRadiusUsecase
    
    init(
        fetchingUserCircleRadiusUsecase: FetchingUserCircleRadiusUsecase = DefaultFetchingUserCircleRadiusUsecase()
    ) {
        self.fetchingUserCircleRadiusUsecase = fetchingUserCircleRadiusUsecase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let goMainScene: PublishRelay<Double> = .init()
        let errorAlertShow: PublishRelay<String> = .init()
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .bind(with: self) { owner, _ in
                owner.fetchingUserCircleRadiusUsecase.execute()
                    .subscribe { userCircleRadius in
                        owner.output.goMainScene.accept(userCircleRadius)
                    } onFailure: { error in
                        owner.output.errorAlertShow.accept(error.localizedDescription)
                    }
                    .disposed(by: disposedBag)
            }
            .disposed(by: disposedBag)
        
        return output
    }
}
