//
//  DropAnimationView.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/24.
//

import UIKit

import Lottie

final class DropAnimationView: UIView {
    init() {
        super.init(frame: .zero)
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let lottieAnimationView: LottieAnimationView = {
        let lottieAnimationView: LottieAnimationView = .init(name: "splashAndDropAnimation")
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.play()
        
        return lottieAnimationView
    }()
}

private extension DropAnimationView {
    func configureUI() {
        self.backgroundColor = .gray900
        self.addSubview(lottieAnimationView)
        
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
