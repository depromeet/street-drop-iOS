//
//  LocationManager.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/22.
//

import CoreLocation
import Foundation

import RxSwift

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var delegate: MainViewModel?
    var viewControllerDelegate: MainViewController?
    private let defaultLocation = CLLocation()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Delegate Methods

extension LocationManager: CLLocationManagerDelegate {
    func checkAuthorizationStatus() -> Bool {
        if locationManager.authorizationStatus == .denied ||
            locationManager.authorizationStatus == .restricted ||
            locationManager.authorizationStatus == .notDetermined {
            viewControllerDelegate?.requestLocationAuthorization()
            return false
        }
        return true
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            viewControllerDelegate?.requestLocationAuthorization()
        case .authorized, .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.startUpdatingLocation()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        delegate?.updateLocation(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.updateLocation(location: defaultLocation)
    }
}
