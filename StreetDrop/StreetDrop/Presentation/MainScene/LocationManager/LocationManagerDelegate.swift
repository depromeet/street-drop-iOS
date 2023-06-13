//
//  LocationManagerDelegate.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/22.
//

import CoreLocation
import Foundation

import RxSwift

protocol LocationManagerDelegate: AnyObject {
    func updateLocation(location: CLLocation) 
}
