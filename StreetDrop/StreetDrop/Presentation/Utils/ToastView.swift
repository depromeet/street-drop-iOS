//
//  ToastView.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/07.
//

import UIKit

import SnapKit

final class ToastView: UIView {

    enum State {
        case success
        case fail

        var icon: UIImage? {
            switch self {
            case .success:
                return UIImage(named: "toastSuccessIcon")
            case .fail:
                return UIImage(named: "toastFailIcon")
            }
        }
    }

    init(state: State, text: String) {
        super.init(frame: .zero)
        iconImageView.image = state.icon
        textLabel.text = text
        configureUI()
    }

    convenience init(state: State, text: String, buttonTitle: String, buttonAction: UIAction) {
        self.init(state: state, text: text)
        button.setTitle(buttonTitle, for: .normal)
        addButton(action: buttonAction)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private lazy var iconImageView: UIImageView = UIImageView()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray50
        label.font = .pretendard(size: 14, weightName: .medium)

        return label
    }()

    private lazy var containerStackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4

        return stackView
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray600
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .pretendard(size: 12, weightName: .semiBold)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true

        return button
    }()
}

// MARK: - Private

private extension ToastView {
    func configureUI() {
        backgroundColor = .gray700
        layer.cornerRadius = 12
        clipsToBounds = true

        [iconImageView, textLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }

        addSubview(containerStackView)

        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        containerStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(8)
        }
    }

    func addButton(action: UIAction) {
        containerStackView.addArrangedSubview(button)
        button.addAction(action, for: .touchUpInside)

        button.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(-4)
        }

        button.titleLabel?.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }
}
