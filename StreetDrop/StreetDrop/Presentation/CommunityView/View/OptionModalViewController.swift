//
//  OptionModalViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class OptionModalViewController: UIViewController {

    enum Constant {
        static let editTitle: String = "수정하기"
        static let deleteTitle: String = "삭제하기"
    }

    private let viewModel: OptionModalViewModel
    private let disposeBag = DisposeBag()

    //MARK: - UI

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0

        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 20
        view.clipsToBounds = true

        return view
    }()

    private lazy var optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    private lazy var dividingLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray600
        return view
    }()

    private lazy var editButton: UIButton = generateOptionButton(
        icon: UIImage(named: "editIcon"),
        title: Constant.editTitle
    )

    private lazy var deleteButton: UIButton = generateOptionButton(
        icon: UIImage(named: "deleteIcon"),
        title: Constant.deleteTitle
    )

    //MARK: - Life Cycle

    init(viewModel: OptionModalViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //나타날때 모달 뒤 화면 뿌옇게
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0.25
        }
    }
}

private extension OptionModalViewController {

    // MARK: - Action Binding

    func bindAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismiss(_:))
        )
        dimmedView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = OptionModalViewModel.Input(
            tapEditOption: editButton.rx.tap.asObservable(),
            tapDeleteOption: deleteButton.rx.tap.asObservable()
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
        let defaultHeigh: CGFloat = 176
        [editButton, dividingLineView, deleteButton].forEach {
            optionStackView.addArrangedSubview($0)
        }

        containerView.addSubview(optionStackView)

        [dimmedView, containerView].forEach {
            view.addSubview($0)
        }

        dimmedView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeigh)
        }

        optionStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        dividingLineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.height.equalTo(deleteButton.snp.height)
        }
    }
}

//MARK: - Private
private extension OptionModalViewController {
    func generateOptionButton(icon: UIImage?, title: String) -> UIButton {
        //ui
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray100, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)

        if let titleLabel = button.titleLabel {
            button.imageView?.snp.makeConstraints {
                $0.width.height.equalTo(20)
                $0.trailing.equalTo(titleLabel.snp.leading).offset(-4)
            }
        }

        return button
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer? = nil) {
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = 0
        }
        self.dismiss(animated: true)
    }
}
