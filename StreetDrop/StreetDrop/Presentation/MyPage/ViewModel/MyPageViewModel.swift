//
//  MyPageViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import Foundation

import RxSwift
import RxRelay

protocol MyPageViewModel: ViewModel {
    
}

final class DefaultMyPageViewModel: MyPageViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    struct Input {}
    
    struct Output {}
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
