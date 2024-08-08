//
//  FetchingCityAndDistrictsUseCase.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/1/24.
//

import Foundation

import OrderedCollections

protocol FetchingCityAndDistrictsUseCase {
    func execute() throws -> OrderedDictionary<String, [String]>
}
