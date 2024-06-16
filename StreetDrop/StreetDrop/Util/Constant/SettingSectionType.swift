//
//  SettingSectionType.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

struct SettingSectionType: Hashable {
    let section: SettingSection
    let items: [SettingItem]
}

enum SettingSection: Hashable {
    case appSettings
    case servicePolicies
    
    var title: String {
        switch self {
        case .appSettings: return "앱 설정"
        case .servicePolicies: return "서비스 운영 및 정책"
        }
    }
}

enum SettingItem: Hashable {
    /// appSettings
    case musicApp(MusicApp)
    case pushNotifications
    
    /// servicePolicies
    case notice(Bool)
    case serviceUsageGuide
    case privacyPolicy
    case feedback
    
    var title: String {
        switch self {
        case .musicApp: return "스트리밍 서비스 선택"
        case .pushNotifications: return "푸쉬 알림"
        case .notice: return "공지사항"
        case .serviceUsageGuide: return "서비스 이용 가이드"
        case .privacyPolicy: return "개인정보 처리방침"
        case .feedback: return "피드백"
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .notice:
            return UIImage(named: "goTo")
        case .serviceUsageGuide, .privacyPolicy, .feedback:
            return UIImage(named: "goOut")
        default:
            return nil
        }
    }
    
    var urlAddress: String? {
        switch self {
        case .serviceUsageGuide:
            return "https://www.notion.so/streetdrop/d3d5bb5808a5499f9f98428d5753ee58?pvs=4"
        case .privacyPolicy:
            return "https://plip.kr/pcc/2bb0b6a6-1ff7-467b-80ec-df0ff70aee02/privacy/2.html"
        case .feedback:
            return "https://docs.google.com/forms/d/e/1FAIpQLSfFMNdRomVqIt-XKOpLc10TyR80OXHG0ZpLYW6Fl2ky7NmI4A/viewform"
        default:
            return nil
        }
    }
}
