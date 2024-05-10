//
//  AlertViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/08.
//

import UIKit

import SnapKit
import RxSwift

typealias AlertCompletion = (() -> ())?

enum AlertType {
    case alert(onConfirm: AlertCompletion)
    case confirm(onConfirm: AlertCompletion, onDeny: AlertCompletion)
}

struct AlertContent {
    let type: AlertType
    let state: AlertViewController.State
    let title: String
    let subText: String
    let image: UIImage?
    let buttonTitle: String
}

final class AlertViewController: UIViewController {
    
    enum State {
        case gray
        case primary
        
        var secondButtonColor: UIColor {
            switch self {
            case .gray:
                return .gray200
            case .primary:
                return .primary500
            }
        }
    }
    
    private var alertContent: AlertContent
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(alertContent: AlertContent) {
        self.alertContent = alertContent
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        stackView.spacing = 4

        return stackView
    }()

    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .white
        label.font = .pretendard(size: 16, weightName: .bold)
        label.setLineHeight(lineHeight: 24)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private lazy var subTextLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .gray300
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()
    
    private lazy var imageView = UIImageView()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTitleLabel.text = alertContent.title
        self.subTextLabel.text = alertContent.subText
        self.imageView.image =  alertContent.image
        
        configureUI()
        configureButtons(
            type: alertContent.type,
            state: alertContent.state,
            title: alertContent.buttonTitle
        )
    }
}

// MARK: - Private Methods

private extension AlertViewController {
    func configureUI() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalTo(278)
            $0.centerX.centerY.equalToSuperview()
        }
        
        
        containerView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(20)
        }
        
        if imageView.image == nil {
            [mainTitleLabel, subTextLabel, buttonStackView].forEach {
                containerStackView.addArrangedSubview($0)
            }
            containerStackView.setCustomSpacing(20, after: subTextLabel)
        } else {
            [mainTitleLabel, imageView, buttonStackView].forEach {
                containerStackView.addArrangedSubview($0)
            }
            containerStackView.setCustomSpacing(20, after: imageView)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
    
    func configureButtons(
        type: AlertType,
        state: State,
        title: String
    ) {
        switch type {
        case .alert(let onConfirm):
            let button = addActionButton(
                title: title,
                titleColor: .gray900,
                backgrondColor: state.secondButtonColor
            )
            button.rx.tap
                .bind { onConfirm?() }
                .disposed(by: disposeBag)
        case .confirm(let onConfirm, let onDeny):
            let denyButton = addActionButton(
                title: "취소",
                titleColor: .gray100
            )
            denyButton.rx.tap
                .bind(with: self) { owner, _ in
                    onDeny == nil ? owner.popView() : onDeny?()
                }
                .disposed(by: disposeBag)
            
            let confirmButton = addActionButton(
                title: title,
                titleColor: .gray900,
                backgrondColor: state.secondButtonColor
            )
            confirmButton.rx.tap
                .bind { onConfirm?() }
                .disposed(by: disposeBag)
        }
    }
    
    func addActionButton(
        title: String? = nil,
        titleColor: UIColor = .black,
        backgrondColor: UIColor = .gray500
    ) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgrondColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        buttonStackView.addArrangedSubview(button)
        
        return button
    }
    
    func popView() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
