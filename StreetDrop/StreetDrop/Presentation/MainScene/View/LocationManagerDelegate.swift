//
//  LocationManagerDelegate.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/22.
//

import CoreLocation
import Foundation

protocol LocationManagerDelegate: AnyObject {
    func drawCurrentLocationMarker(location: CLLocation)
}
