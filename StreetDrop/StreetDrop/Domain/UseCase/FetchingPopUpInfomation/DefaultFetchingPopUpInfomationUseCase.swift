//
//  DefaultFetchingPopUpInfomationUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

import RxSwift

final class DefaultFetchingPopUpInfomationUseCase: FetchingPopUpInfomationUseCase {
    private let repository: PopUpRepository
    
    init(repository: PopUpRepository = DefaultPopUpRepository()) {
        self.repository = repository
    }
    
    func execute() -> Single<[PopUpInfomation]> {
        return repository.fetchPopUpInfomation()
    }
}
