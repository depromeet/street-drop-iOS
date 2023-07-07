//
//  ClaimModalViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/26.
//

import UIKit

import SnapKit

import RxSwift
import RxRelay

enum Claim: CaseIterable {
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

final class ClaimModalViewController: UIViewController {

    private enum Constant {
        static let title: String = "신고하기"
        static let claimGuideText: String = "신고 사유를 선택해 주세요"
        static let sendButtonTitle: String = "전송"
    }

    private let viewModel: ClaimModalViewModel
    private let tapClaimOption = PublishRelay<Claim>()
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

    private lazy var claimGuideLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.claimGuideText
        label.textColor = .gray300
        label.font = .pretendard(size: 12, weightName: .semiBold)

        return label
    }()

    private lazy var claimOptionViews: [UIView] = generateClaimOptionViews()

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
        button.setTitleColor(.gray400, for: .disabled)
        button.setTitleColor(.white , for: .normal)
        button.backgroundColor = .gray700
        button.isEnabled = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true

        return button
    }()

    //MARK: - Life Cycle

    init(viewModel: ClaimModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
        bindViewModel()
        configureUI()
    }
}

private extension ClaimModalViewController {

    // MARK: - Action Binding
    func bindAction() {
        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.dismiss()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = ClaimModalViewModel.Input(
            tapClaimOption: self.tapClaimOption.asObservable(),
            tapSendButton: self.sendButton.rx.tap.asObservable()
        )

        let output = viewModel.convert(input: input, disposedBag: disposeBag)

        output.dismiss
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)
    }

    // MARK: - UI

    func configureUI() {
        let defaultHeight: CGFloat = 476

        claimOptionViews
            .forEach {
            optionStackView.addArrangedSubview($0)
        }

        [titleView, closeButton, dividingLineView, claimGuideLabel, optionStackView, sendButton]
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

        claimGuideLabel.setContentHuggingPriority(.required, for: .vertical)

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

        claimGuideLabel.snp.makeConstraints {
            $0.top.equalTo(dividingLineView).offset(12)
            $0.leading.equalToSuperview().inset(28)
        }

        optionStackView.snp.makeConstraints {
            $0.top.equalTo(claimGuideLabel.snp.bottom).offset(4)
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
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(defaultHeight)
        }
    }
}

//MARK: - Private
private extension ClaimModalViewController {
    func generateClaimOptionViews() -> [UIView] {
        var views: [UIView] = []

        Claim.allCases.forEach {
            // UI
            let icon = UIImage(named: "checkIcon")
            let iconView = UIImageView(image: icon)
            iconView.isHidden = true

            let label = UILabel()
            label.textColor = .gray100
            label.text = $0.title
            label.font = .pretendard(size: 16, weightName: .medium)

            let view = UIView()
            view.layer.cornerRadius = 8
            view.clipsToBounds = true

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

            // Action binding
            let tapGesture = ClaimOptionTapGesture(
                target: self,
                action: #selector(tappedClaimOption(_:))
            )

            tapGesture.tappedView = view
            tapGesture.iconView = iconView
            tapGesture.tappedClaimOption = $0

            view.addGestureRecognizer(tapGesture)
            views.append(view)
        }

        return views
    }

    @objc func tappedClaimOption(_ sender: ClaimOptionTapGesture) {
        guard let tappedView = sender.tappedView,
              let iconView = sender.iconView,
              let claimOption = sender.tappedClaimOption else { return }

        tapClaimOption.accept(claimOption)
        resetAllOptionView()
        tappedView.backgroundColor = .gray700
        iconView.isHidden = false
        sendButton.isEnabled = true
        sendButton.backgroundColor = .gray600
    }

    func resetAllOptionView() {
        for view in claimOptionViews {
            view.backgroundColor = .clear
            view.subviews
                .compactMap{ $0 as? UIImageView }
                .forEach { $0.isHidden = true }
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        }
        self.dismiss(animated: true)
    }
}

// MARK: - TapGesture
// objc 메서드로 파라미터 전달위해 UITapGestureRecognizer 상속사용
class ClaimOptionTapGesture: UITapGestureRecognizer {
    var tappedView: UIView?
    var iconView: UIImageView?
    var tappedClaimOption: Claim?
}
