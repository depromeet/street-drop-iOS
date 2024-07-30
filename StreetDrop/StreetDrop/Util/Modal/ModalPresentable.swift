//
//  ModalPresentable.swift
//  StreetDrop
//
//  Created by 차요셉 on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

protocol ModalPresentable where Self: UIViewController {
    var modalContainerView: UIView { get }
    var containerViewTopConstraint: Constraint? { get set }
    var disposeBag: DisposeBag { get }
    var upperMarginHeight: CGFloat { get }
    func setupModal()
    func animatePresentation()
    func bindPanGesture()
}

extension ModalPresentable {
    func setupModal() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        modalContainerView.layer.cornerRadius = 20
        modalContainerView.clipsToBounds = true
        view.addSubview(modalContainerView)

        modalContainerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().offset(-upperMarginHeight)
            containerViewTopConstraint = $0.top.equalTo(view.snp.bottom).constraint
        }

        bindPanGesture()
    }

    func animatePresentation() {
        modalContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(upperMarginHeight)
        }

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func bindPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        modalContainerView.addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.rx.event
            .bind(with: self) { owner, gesture in
                owner.handlePanGesture(gesture)
            }
            .disposed(by: disposeBag)
    }

    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                modalContainerView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(upperMarginHeight + translation.y)
                }
            }
        case .ended:
            if translation.y > 100 || velocity.y > 1000 {
                dismiss(animated: true, completion: nil)
                return
            }
            
            animatePresentation()
        default:
            break
        }
    }
}
