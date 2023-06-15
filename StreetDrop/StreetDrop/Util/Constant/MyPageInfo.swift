//
//  MyPageInfo.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import Foundation

enum MyPageInfo: String, CaseIterable {
//    case serviceUsageGuide = "서비스 이용 안내"
//    case termsAndConditions = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
//    case copyrightInformation = "저작권 정보"
    
    // FIXME: 노션 페이지 url 받으면 변경
    var urlAddress: String {
        switch self {
//        case .serviceUsageGuide:
//            return "https://www.naver.com"
//        case .termsAndConditions:
//            return "https://github.com/depromeet/street-drop-iOS"
        case .privacyPolicy:
            return "https://plip.kr/pcc/2bb0b6a6-1ff7-467b-80ec-df0ff70aee02/privacy/2.html"
//        case .copyrightInformation:
//            return "https://www.daum.net"
        }
    }
}
