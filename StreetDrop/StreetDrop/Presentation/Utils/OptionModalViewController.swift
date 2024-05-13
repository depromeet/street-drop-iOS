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

    //MARK: - Life Cycle

    init(
        firstOption: ModalOption,
        secondOption: ModalOption,
        thirdOption: ModalOption
    ) {
        super.init(nibName: nil, bundle: nil)
        
        configureOptions(
            firstOption: firstOption,
            secondOption: secondOption,
            thirdOption: thirdOption
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    private var firstOptionButton: UIButton = UIButton()
    private var secondOptionButton: UIButton = UIButton()
    private var thirdOptionButton: UIButton = UIButton()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
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

    // MARK: - UI
    
    func configureOptions(
        firstOption: ModalOption,
        secondOption: ModalOption,
        thirdOption: ModalOption
    ) {
        self.firstOptionButton = self.generateOptionButton(
            icon: firstOption.icon,
            title: firstOption.title
        )

        self.secondOptionButton = self.generateOptionButton(
            icon: secondOption.icon,
            title: secondOption.title
        )
        
        self.thirdOptionButton = self.generateOptionButton(
            icon: thirdOption.icon,
            title: thirdOption.title
        )

        firstOptionButton.addAction(firstOption.acton, for: .touchUpInside)
        secondOptionButton.addAction(secondOption.acton, for: .touchUpInside)
        thirdOptionButton.addAction(thirdOption.acton, for: .touchUpInside)
    }

    func configureUI() {
        let firstDividingLineView = generateDividingView()
        let secondDividingLineView = generateDividingView()
        
        let defaultHeigh: CGFloat = 224
        [
            firstOptionButton,
            firstDividingLineView,
            secondOptionButton,
            secondDividingLineView,
            thirdOptionButton
        ].forEach {
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

        firstDividingLineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        secondDividingLineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
        }

        firstOptionButton.snp.makeConstraints {
            $0.height.equalTo(secondOptionButton.snp.height)
        }
        
        secondOptionButton.snp.makeConstraints {
            $0.height.equalTo(thirdOptionButton.snp.height)
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
    
    func generateDividingView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray600
        return view
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer? = nil) {
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = 0
        }
        self.dismiss(animated: true)
    }
}
