//
//  Bundle+APIKeys.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/13.
//

import Foundation

extension Bundle {
    var naverMapsClientID: String {
        guard let file = self.path(forResource: "NaverMaps", ofType: "plist") else {
            fatalError("NaverMaps.plist 파일이 없습니다.")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let clientID = resource["NMFClientId"] as? String else {
            fatalError("NaverMaps에 NMFClientId을 설정해주세요.")
        }
        return clientID
    }
}
