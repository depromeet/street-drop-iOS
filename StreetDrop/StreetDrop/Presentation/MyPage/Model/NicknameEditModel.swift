//
//  NicknameEditModel.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/20.
//

import Foundation

import RxSwift

protocol NicknameEditModel {
    func editNickname(nickname: String) -> Single<Void>
}

final class DefaultNicknameEditModel: NicknameEditModel {
    private let repository: NicknameEditRepository

    init(
        repository: NicknameEditRepository
    ) {
        self.repository = repository
    }
    
    func editNickname(nickname: String) -> Single<Void> {
        return repository.editNickname(nickname: nickname)
    }
}
