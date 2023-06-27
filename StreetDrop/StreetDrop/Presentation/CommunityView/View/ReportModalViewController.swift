//
//  ReportModalViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/26.
//

import UIKit

import SnapKit
import RxSwift

final class ReportModalViewController: UIViewController {

    private enum Report: CaseIterable {
        case slander, disgust, violent, falseInformation, etc

        var title: String {
            switch self {
            case .slander:
                return "욕설/비방"
            case .disgust:
                return "혐오 발언 또는 상징"
            case .violent:
                return "폭력 또는 위험한 단체"
            case .falseInformation:
                return "거짓 정보"
            case .etc:
                return "기타"
            }
        }
    }

    private enum Constant {
        static let title: String = "신고하기"
        static let reportGuideText: String = "신고 사유를 선택해 주세요"
        static let sendButtonTitle: String = "전송"
    }

    // modal 애니메이션을 위한 제약조건
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private let disposeBag: DisposeBag = DisposeBag()

    //MARK: - UI

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.25

        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleView: UIView = {
        let icon = UIImage(named: "sirenIcon")
        let iconImageView = UIImageView(image: icon)
        let label = UILabel()
        label.text = Constant.title
        label.textColor = .gray100
        label.font = .pretendard(size: 16, weightName: .medium)

        let view = UIView()
        view.addSubview(iconImageView)
        view.addSubview(label)

        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.leading.bottom.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
        }

        return view
    }()

    private lazy var closeButton: UIButton = {
        let icon = UIImage(named: "closeIcon")
        let button = UIButton()
        button.setImage(icon, for: .normal)

        return button
    }()

    private lazy var dividingLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray600
        return view
    }()

    private lazy var reportGuideLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.reportGuideText
        label.textColor = .gray300
        label.font = .pretendard(size: 12, weightName: .semiBold)

        return label
    }()

    private lazy var reportOptionViews: [UIView] = generateReportOptionViews()

    private lazy var optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually

        return stackView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.sendButtonTitle, for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.backgroundColor = .gray700
        button.isEnabled = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true

        return button
    }()

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
        configureUI()
    }
}

private extension ReportModalViewController {

    // MARK: - Action Binding
    func bindAction() {
        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                UIView.animate(withDuration: 0.3) {
                    self?.dimmedView.alpha = 0
                }
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - UI

    func configureUI() {
        let defaultHeight: CGFloat = 476

        reportOptionViews
            .forEach {
            optionStackView.addArrangedSubview($0)
        }

        [titleView, closeButton, dividingLineView, reportGuideLabel, optionStackView, sendButton]
            .forEach {
                containerView.addSubview($0)
            }

        [dimmedView, containerView]
            .forEach {
                view.addSubview($0)
            }

        titleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
        }

        reportGuideLabel.setContentHuggingPriority(.required, for: .vertical)

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.centerY.equalTo(titleView)
            $0.trailing.equalToSuperview().inset(28)
        }

        dividingLineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(titleView.snp.bottom).offset(20)
        }

        reportGuideLabel.snp.makeConstraints {
            $0.top.equalTo(dividingLineView).offset(12)
            $0.leading.equalToSuperview().inset(28)
        }

        optionStackView.snp.makeConstraints {
            $0.top.equalTo(reportGuideLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(sendButton.snp.top).offset(-12)
        }

        sendButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(56)
        }

        dimmedView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(-defaultHeight)
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        containerViewHeightConstraint = containerView.heightAnchor.constraint(
            equalToConstant: defaultHeight
        )
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )

        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true

    }
}

//MARK: - Private
private extension ReportModalViewController {
    func generateReportOptionViews() -> [UIView] {
        var views: [UIView] = []

        Self.Report.allCases.forEach {
            // UI
            let icon = UIImage(named: "checkIcon")
            let iconView = UIImageView(image: icon)
            iconView.isHidden = false

            let label = UILabel()
            label.textColor = .gray100
            label.text = $0.title
            label.font = .pretendard(size: 16, weightName: .medium)

            let view = UIView()
            view.layer.cornerRadius = 8
            view.clipsToBounds = true
            view.backgroundColor = .gray700

            // configure Layout
            view.addSubview(iconView)
            view.addSubview(label)

            iconView.snp.makeConstraints {
                $0.width.height.equalTo(24)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }

            label.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(12)
                $0.leading.equalToSuperview().inset(16)
            }

            views.append(view)
        }

        return views
    }
}
