//
//  UniviersialLinkKey.swift
//  StreetDrop
//
//  Created by thoonk on 1/2/24.
//

import Foundation

enum UniviersialLinkKey {
    case sharingMusic
}

extension UniviersialLinkKey {
    var urlString: String {
        switch self {
        case .sharingMusic:
#if DEBUG // 테스트 서버 주소
            return "https://test-open.street-drop.com"
#elseif RELEASE // 실 서버 주소
            return "https://open.street-drop.com"
#endif
        }
    }
}
