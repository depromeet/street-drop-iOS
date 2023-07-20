//
//  SettingsInfo.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import Foundation

enum SettingsInfo: String, CaseIterable {
    case serviceUsageGuide = "서비스 이용 가이드"
    case privacyPolicy = "개인정보 처리방침"
    case feedback = "피드백"
    
    var urlAddress: String {
        switch self {
        case .serviceUsageGuide:
            return "https://www.notion.so/streetdrop/d3d5bb5808a5499f9f98428d5753ee58?pvs=4"
        case .privacyPolicy:
            return "https://plip.kr/pcc/2bb0b6a6-1ff7-467b-80ec-df0ff70aee02/privacy/2.html"
        case .feedback:
            return "https://docs.google.com/forms/d/e/1FAIpQLSfFMNdRomVqIt-XKOpLc10TyR80OXHG0ZpLYW6Fl2ky7NmI4A/viewform"
        }
    }
}
