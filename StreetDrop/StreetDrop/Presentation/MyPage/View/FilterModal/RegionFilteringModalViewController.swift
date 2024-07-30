//
//  RegionFilteringModalViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift

final class RegionFilteringModalViewController: UIViewController, ModalPresentable {
    var upperMarginHeight: CGFloat = 158
    var containerViewTopConstraint: Constraint?
    let disposeBag: DisposeBag = .init()
    
    let modalContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModal()
        configureUI()
    }
}

private extension RegionFilteringModalViewController {
    func configureUI() {
        
    }
}
