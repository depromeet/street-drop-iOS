//
//  AlertViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/08.
//

import UIKit

import SnapKit
import RxSwift

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

    private let disposeBag: DisposeBag = DisposeBag()

    init(
        state: State,
        title: String,
        subText: String,
        confirmButtonTitle: String,
        confirmButtonAction: UIAction
    ) {
        super.init(nibName: nil, bundle: nil)
        self.mainTitleLabel.text = title
        self.subTextLabel.text = subText
        self.confirmButton.backgroundColor = state.secondButtonColor
        self.confirmButton.setTitle(confirmButtonTitle, for: .normal)
        self.addConfirmButtonAction(confirmButtonAction)
        configureUI()
        bindCancelButtonAction()
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

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray100, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        button.backgroundColor = .gray500
        button.layer.cornerRadius = 8
        button.clipsToBounds = true

        return button
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true

        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        return stackView
    }()
}

private extension AlertViewController {
    func configureUI() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)

        [cancelButton, confirmButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }

        [mainTitleLabel, subTextLabel, buttonStackView].forEach {
            containerStackView.addArrangedSubview($0)
        }

        containerView.addSubview(containerStackView)
        self.view.addSubview(containerView)

        containerStackView.setCustomSpacing(20, after: subTextLabel)

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.centerY.equalToSuperview()
        }

        containerStackView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(20)
        }

        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }

    func bindCancelButtonAction() {
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func addConfirmButtonAction(_ action: UIAction) {
        confirmButton.addAction(action, for: .touchUpInside)
    }
}
