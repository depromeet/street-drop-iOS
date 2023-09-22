//
//  DefaultMyInfoUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultMyInfoUseCase: MyInfoUseCase {
    private let mainRepository: MainRepository
    
    init(mainRepository: MainRepository) {
        self.mainRepository = mainRepository
    }
    
    func fetchMyInfo() -> Single<MyInfo> {
        return mainRepository.fetchMyInfo()
    }
    
    func saveMyInfo(_ myInfo: MyInfo) -> Single<Void> {
        return mainRepository.saveMyInfo(myInfo)
    }
}
