//
//  LevelPolicyPopUpViewController.swift
//  StreetDrop
//
//  Created by thoonk on 4/20/24.
//

import UIKit

import SnapKit
import RxSwift

final class LevelPolicyPopUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let levelPolicies: [LevelPolicy]
    private let disposeBag: DisposeBag = .init()
    
    // MARK: - UI

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 12
        view.clipsToBounds = true

        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12

        return stackView
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "레벨 등급 안내"
        label.textColor = .white
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 24)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("닫기", for: .normal)
        button.backgroundColor = .gray200
        button.roundCorners(.allCorners, radius: 8)
        
        return button
    }()
    
    // MARK: - Init
    
    init(
        levelPolicies: [LevelPolicy]
    ) {
        self.levelPolicies = levelPolicies
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        configureUI()
        bindAction()
    }
}

// MARK: - Private Methods

private extension LevelPolicyPopUpViewController {
    func configureUI() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalTo(294)
            $0.height.equalTo(376)
            $0.centerX.centerY.equalToSuperview()
        }
        
        containerView.addSubview(mainTitleLabel)
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview().inset(41.5)
            $0.height.equalTo(28)
        }
        
        containerView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(41.5)
        }
        
        levelPolicies.forEach { levelPolicy in
            let levelPolicySubView = LevelPolicySubView(isGradient: levelPolicy.level == 3)
            bindSubView(levelPolicySubView, levelPolicy: levelPolicy)
            containerStackView.addArrangedSubview(levelPolicySubView)
        }
        
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(28)
            $0.height.equalTo(44)
        }
    }
    
    func bindAction() {
        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindSubView(_ view: LevelPolicySubView, levelPolicy: LevelPolicy) {
        Observable.just(levelPolicy)
            .bind(to: view.rx.setLevelPolicy)
            .disposed(by: disposeBag)
    }
}
