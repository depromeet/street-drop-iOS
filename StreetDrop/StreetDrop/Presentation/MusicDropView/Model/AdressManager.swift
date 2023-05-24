//
//  AdressManager.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/21.
//

import Foundation

import CoreLocation
import RxSwift

// MapView에서 위치데이터 가져오는 locationManager 구성했을거라 예상해서 추후에 여기 코드와 합쳐야 함
protocol AdressManager {
    func fetchAdress(latitude: Double, longitude: Double) -> Observable<String>
}

final class DefaultAdressManager: NSObject {

}

extension DefaultAdressManager: AdressManager {
    func fetchAdress(latitude: Double, longitude: Double) -> Observable<String> {
        let geocoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)

        return Observable.create() { observer in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else {
                    print("DefaultAdressManager - reverseGeocodeLocation Error Occured")
                    print(error?.localizedDescription)
                    return
                }

                guard let placemark =  placemarks?.first,
                      let locality = placemark.locality,
                      let thoroughfare = placemark.thoroughfare else {
                    print("DefaultAdressManager - failed reverse to Geocode Location")
                    return
                }

                let adress = "\(locality) \(thoroughfare)" //영통구 이의동
                observer.onNext(adress)
            }

            return Disposables.create()
        }
    }
}
