//
//  DefaultPostingPopUpUserReadingUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/8/24.
//

import Foundation

import RxSwift

final class DefaultPostingPopUpUserReadingUseCase: PostingPopUpUserReadingUseCase {
    private let repository: PopUpRepository
    
    init(repository: PopUpRepository = DefaultPopUpRepository()) {
        self.repository = repository
    }
    
    func execute(type: String, id: Int) -> Single<Void> {
        return repository.postPopUpUserReading(type: type, id: id)
    }
}
