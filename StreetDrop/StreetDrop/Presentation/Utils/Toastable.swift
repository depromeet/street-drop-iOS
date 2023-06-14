//
//  Toastable.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/14.
//

import UIKit

import SnapKit

// 1차 베타 버전에만 사용예정
protocol Toastable { }

extension Toastable where Self: UIViewController {
    func showFailDropToast() {
        let toast = UIImage(named: "toast_failDrop")
        let toastImageView = UIImageView(image: toast)
        toastImageView.contentMode = .scaleAspectFit

        self.view.addSubview(toastImageView)
        toastImageView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(96.4)
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(toastImageView.snp.width).multipliedBy(0.28)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            toastImageView.removeFromSuperview()
        })
    }

    func showSuccessDropToast() {
        let toast = UIImage(named: "toast_successDrop")
        let toastImageView = UIImageView(image: toast)
        toastImageView.contentMode = .scaleAspectFit

        self.view.addSubview(toastImageView)
        toastImageView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(96.4)
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(toastImageView.snp.width).multipliedBy(0.28)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            toastImageView.removeFromSuperview()
        })
    }

    func showWaitingOpenToast() {
        let toast = UIImage(named: "toast_waitingOpen")
        let toastImageView = UIImageView(image: toast)
        toastImageView.contentMode = .scaleAspectFit

        self.view.addSubview(toastImageView)
        toastImageView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(96.4)
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(toastImageView.snp.width).multipliedBy(0.28)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            toastImageView.removeFromSuperview()
        })
    }
}
