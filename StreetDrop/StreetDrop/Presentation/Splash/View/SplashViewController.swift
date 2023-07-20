//
//  SplashViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/16.
//

import UIKit

import Lottie

final class SplashViewController: UIViewController {
    private let lottieAnimationView: LottieAnimationView = {
        let lottieAnimationView: LottieAnimationView = .init(name: "splashAndDropAnimation")
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.play()
        
        return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindAction()
    }
}

private extension SplashViewController {
    func bindAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            let mainViewController = MainViewController()
            
            let navigationController = UINavigationController(
                rootViewController: mainViewController
            )
            
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            self?.present(navigationController, animated: true)
        })
    }
    
    func configureUI() {
        view.backgroundColor = .gray900
        self.view.addSubview(lottieAnimationView)
        
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
