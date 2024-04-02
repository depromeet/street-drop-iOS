//
//  PopUpRepository.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import Foundation

import RxSwift

protocol PopUpRepository {
    func fetchPopUpInfomation() -> Single<[PopUpInfomation]>
}
