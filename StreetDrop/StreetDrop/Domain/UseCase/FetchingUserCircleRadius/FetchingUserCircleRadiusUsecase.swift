//
//  FetchingUserCircleRadiusUsecase.swift
//  StreetDrop
//
//  Created by 차요셉 on 2/6/24.
//

import Foundation

import RxSwift

protocol FetchingUserCircleRadiusUsecase {
    func execute() -> Single<Double>
}
