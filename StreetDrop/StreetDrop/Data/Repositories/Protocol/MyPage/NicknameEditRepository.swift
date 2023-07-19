//
//  NicknameEditRepository.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/20.
//

import Foundation

import RxSwift

protocol NicknameEditRepository {
    func editNickname(nickname: String) -> Single<Void>
}
