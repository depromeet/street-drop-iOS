//
//  Alertable.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/14.
//

import UIKit

import RxSwift

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
#if SHARE_EXTENSION_TARGET
#else
                // 기본 동작 또는 다른 타겟의 경우
                UIApplication.shared.open(appSetting)
#endif
            }
        }

        let cancel = UIAlertAction(title: "취소", style: .destructive)

        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancel)
        present(requestLocationServiceAlert, animated: true)
    }

    func showAlert(
        type: AlertType,
        state: AlertViewController.State,
        title: String,
        subText: String,
        image: UIImage? = nil,
        buttonTitle: String
    ) {
        let alertContent = AlertContent(
            type: type,
            state: state,
            title: title,
            subText: subText,
            image: image,
            buttonTitle: buttonTitle
        )
        
        let alertView = AlertViewController(alertContent: alertContent)
        popupAlert(view: alertView)
    }
    
    func showLevelPolicy(_ levelPolicies: [LevelPolicy]) {
        let levelPolicyPopupView = LevelPolicyPopUpViewController(levelPolicies: levelPolicies)
        levelPolicyPopupView.modalPresentationStyle = .overFullScreen
        levelPolicyPopupView.modalTransitionStyle = .crossDissolve
        
        present(levelPolicyPopupView, animated: true)
    }
    
    func popupAlert(view: AlertViewController) {
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve

        if let navigationController = navigationController {
            navigationController.present(view, animated: true)
        } else {
            present(view, animated: true)
        }
    }
    
    func showTipPopUp(
        contentTitle: String,
        contentDescription: String,
        nextAction: @escaping () -> (),
        cancelAction: @escaping () -> (),
        disposeBag: DisposeBag
    ){
        let tipPopUpViewController: TipPopUpViewController = .init(
            contentTitle: contentTitle,
            contentDescription: contentDescription
        )

        tipPopUpViewController.modalPresentationStyle = .overFullScreen
        tipPopUpViewController.modalTransitionStyle = .crossDissolve

        tipPopUpViewController.nextActionButtonClickedEvent
            .bind {
                nextAction()
            }
            .disposed(by: disposeBag)
        
        tipPopUpViewController.cancelButtonClickedEvent
            .bind {
                cancelAction()
            }
            .disposed(by: disposeBag)
        
        if let navigationController = navigationController {
            navigationController.present(tipPopUpViewController, animated: true)
        } else {
            present(tipPopUpViewController, animated: true)
        }
    }
    
    func showCongratulationsLevelUpPopUp(
        contentTitle: String,
        contentDescription: String,
        popupName: String,
        remainCount: Int?,
        nextAction: @escaping () -> (),
        disposeBag: DisposeBag
    ){
        let congratulationsLevelUpPopUpViewController: CongratulationsLevelUpPopUpViewController = .init(
            contentTitle: contentTitle,
            contentDescription: contentDescription, 
            popupName: popupName,
            remainCount: remainCount
        )

        congratulationsLevelUpPopUpViewController.modalPresentationStyle = .overFullScreen
        congratulationsLevelUpPopUpViewController.modalTransitionStyle = .crossDissolve

        congratulationsLevelUpPopUpViewController.closeButtonEvent
            .bind {
                nextAction()
            }
            .disposed(by: disposeBag)
        
        if let navigationController = navigationController {
            navigationController.present(congratulationsLevelUpPopUpViewController, animated: true)
        } else {
            present(congratulationsLevelUpPopUpViewController, animated: true)
        }
    }
}
