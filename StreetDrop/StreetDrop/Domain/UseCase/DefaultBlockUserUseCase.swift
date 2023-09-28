//
//  DefaultBlockUserUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/09/22.
//

import Foundation

import RxSwift

final class DefaultBlockUserUseCase: BlockUserUseCase {
    private let blockUserRepository: BlockUserRepository
    
    init(
        blockUserRepository: BlockUserRepository = DefaultBlockUserRepository()
    ) {
        self.blockUserRepository = blockUserRepository
    }
    
    func execute(_ blockUserID: Int) -> Single<Int> {
        return blockUserRepository.blockUser(blockUserID)
    }
}
