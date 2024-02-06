//
//  SplashViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/16.
//

import UIKit

import Lottie
import RxSwift

final class SplashViewController: UIViewController, Alertable {
    private let viewModel: SplashViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    private let lottieAnimationView: LottieAnimationView = {
        let lottieAnimationView: LottieAnimationView = .init(name: "splashAndDropAnimation")
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.play()
        
        return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
}

private extension SplashViewController {
    func bindViewModel() {
        let input: SplashViewModel.Input = .init(viewDidLoadEvent: .just(Void()))
        let output: SplashViewModel.Output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.errorAlertShow
            .bind(with: self) { owner, errorMessage in
                let exitAction = UIAction {_ in
                    exit(1)
                }
                
                owner.showAlert(
                    state: .primary,
                    title: "에러 발생",
                    subText: errorMessage,
                    confirmButtonTitle: "확인",
                    confirmButtonAction: exitAction
                )
            }
            .disposed(by: disposeBag)
        
        output.goMainScene
            .bind(with: self) { owner, userCircleRadius in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    let mainViewController = MainViewController(
                        viewModel: .init(userCircleRadius: userCircleRadius)
                    )
                    
                    let navigationController = UINavigationController(
                        rootViewController: mainViewController
                    )
                    
                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.modalTransitionStyle = .crossDissolve
                    owner.present(navigationController, animated: true)
                })
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.backgroundColor = .gray900
        self.view.addSubview(lottieAnimationView)
        
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
