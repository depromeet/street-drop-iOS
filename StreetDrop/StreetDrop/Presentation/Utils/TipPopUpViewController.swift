//
//  TipPopUpViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/2/24.
//

import UIKit

import SnapKit
import RxRelay
import RxSwift

final class TipPopUpViewController: UIViewController {
    private let contentTitle: String
    private let contentDescription: String
    private let nextActionButtonTitle: String
    private let disposeBag: DisposeBag = .init()
    let nextActionButtonEvent: PublishRelay<Void> = .init()
    
    init(
        contentTitle: String,
        contentDescription: String,
        nextActionButtonTitle: String = "드랍해서 레벨업하기" // 나중에 nextActionButtonTitle받아 주입해 사용하도록
    ) {
        self.contentTitle = contentTitle
        self.contentDescription = contentDescription
        self.nextActionButtonTitle = nextActionButtonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        return view
    }()
    
    private let tipBadgeImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "tipBadge"))
        
        return imageView
    }()
    
    private lazy var moreMusicLabel: GradientLabel = {
        let gradientLabel: GradientLabel = .init(
            colors: [
                UIColor(hexString: "#B0C6FF"),
                UIColor(hexString: "#CBB3FF"),
                UIColor(hexString: "#71FFF6"),
                UIColor(hexString: "#F7F7F7"),
                UIColor(hexString: "#DCCCFF")
            ],
            locations: [
                0.1034,
                0.2517,
                0.5688,
                0.7459,
                0.8941
            ]
        )
        gradientLabel.text = contentTitle
        gradientLabel.font = .pretendard(size: 20, weightName: .bold)
        gradientLabel.setLineHeight(lineHeight: 28)
        
        return gradientLabel
    }()
    
    private let tipImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "tipImage"))
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = UIColor.gray50
        label.text = contentDescription
        label.numberOfLines = 0
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private lazy var nextActionButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .primary500
        button.layer.cornerRadius = 8
        button.setTitle(nextActionButtonTitle, for: .normal)
        button.setTitleColor(.gray700, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        
        return button
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        configureUI()
    }
}

private extension TipPopUpViewController {
    func bindAction() {
        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        nextActionButton.rx.tap
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                dismiss(animated: true)
            })
            .bind(to: nextActionButtonEvent)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        view.addSubview(containerView)
        [
            tipBadgeImageView,
            moreMusicLabel,
            tipImageView,
            descriptionLabel,
            nextActionButton,
            closeButton
        ].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(294)
            $0.height.equalTo(409)
            $0.center.equalToSuperview()
        }
        
        tipBadgeImageView.snp.makeConstraints {
            $0.width.equalTo(53)
            $0.height.equalTo(28)
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        moreMusicLabel.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(28)
            $0.top.equalTo(tipBadgeImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        tipImageView.snp.makeConstraints {
            $0.width.equalTo(124)
            $0.height.equalTo(98.17)
            $0.top.equalTo(moreMusicLabel.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(40)
            $0.top.equalTo(tipImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        nextActionButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(nextActionButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
    }
}
