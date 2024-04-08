//
//  PostingPopUpUserReadingUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/8/24.
//

import Foundation

import RxSwift

protocol PostingPopUpUserReadingUseCase {
    func execute(type: String, id: Int) -> Single<Void>
}
