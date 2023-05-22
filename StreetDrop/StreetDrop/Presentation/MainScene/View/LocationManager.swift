//
//  LocationManager.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/22.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var delegate: MainViewController?
    private let defaultLocation = CLLocation(latitude: 37.4979, longitude: 127.0275)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        delegate?.drawCurrentLocationMarker(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            delegate?.drawCurrentLocationMarker(location: defaultLocation)
        default:
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.drawCurrentLocationMarker(location: defaultLocation)
    }
}

extension LocationManager {
    func requestLocation() {
        self.locationManager.requestLocation()
    }
}

