//
//  Alertable.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/14.
//

import UIKit

protocol Alertable { }

// POP 기본구현
extension Alertable where Self: UIViewController {
    func showLocationServiceRequestAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 권한 없음",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )

        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }

        let cancel = UIAlertAction(title: "취소", style: .destructive)

        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancel)
        present(requestLocationServiceAlert, animated: true)
    }
}
