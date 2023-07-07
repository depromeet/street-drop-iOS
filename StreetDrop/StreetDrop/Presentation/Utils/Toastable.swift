//
//  Toastable.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/14.
//

import UIKit

import SnapKit

protocol Toastable where Self: UIViewController { }

extension Toastable {

    func showSuccessNormalToast(text: String, bottomInset: CGFloat, duration: DispatchTime) {
        let toastView = ToastView(state: .success, text: text)
        showToast(toastView, bottomInset: bottomInset, duration: duration)
    }

    func showFailNormalToast(text: String, bottomInset: CGFloat, duration: DispatchTime) {
        let toastView = ToastView(state: .fail, text: text)
        showToast(toastView, bottomInset: bottomInset, duration: duration)
    }

    func showSuccessButtonToast(
        text: String,
        bottomInset: CGFloat,
        buttonTitle: String,
        duration: DispatchTime
    ) {
        let toastView = ToastView(state: .success, text: text, buttonTitle: buttonTitle)
        showToast(toastView, bottomInset: bottomInset, duration: duration)
    }

    func showFailButtonToast(
        text: String,
        bottomInset: CGFloat,
        buttonTitle: String,
        duration: DispatchTime
    ) {
        let toastView = ToastView(state: .fail, text: text, buttonTitle: buttonTitle)
        showToast(toastView, bottomInset: bottomInset, duration: duration)
    }
}

// MARK: - Private

private extension Toastable {
    func showToast(_ toastView: ToastView, bottomInset: CGFloat, duration: DispatchTime) {
        self.view.addSubview(toastView)

        toastView.snp.makeConstraints {
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(bottomInset)
        }

        DispatchQueue.main.asyncAfter(deadline: duration, execute: {
            toastView.removeFromSuperview()
        })
    }
}
