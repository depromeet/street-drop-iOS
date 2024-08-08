//
//  CityAndDistrictsDTO.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/1/24.
//

import Foundation
import OrderedCollections

struct CityAndDistrictsDTO: Decodable {
    let informations: [CityInfomaion]
    
    struct CityInfomaion: Decodable {
        let name: String
        let districts: [String]
    }
}

extension CityAndDistrictsDTO {
    func toDictionary() -> OrderedDictionary<String, [String]> {
        var orderedDictionary = OrderedDictionary<String, [String]>()
        informations.forEach {
            orderedDictionary[$0.name] = $0.districts
        }
        
        return orderedDictionary
    }
}
