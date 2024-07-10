//
//  Map+Rx.swift
//  StreetDrop
//
//  Created by thoonk on 7/10/24.
//

import Foundation

import RxSwift

extension ObservableType {
    func map<T>(_ element: T) -> Observable<T> {
        self.map({ _ in element })
    }
    
    func mapVoid() -> Observable<Void> {
        self.map(Void())
    }
}
