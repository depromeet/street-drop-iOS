//
//  ViewModel.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/02.
//

import Foundation

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output
}
