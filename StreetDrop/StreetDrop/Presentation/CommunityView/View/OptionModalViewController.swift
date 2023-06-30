//
//  OptionModalViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import UIKit

import SnapKit

final class OptionModalViewController: UIViewController {

    enum Constant {
        static let reviseTitle: String = "수정하기"
        static let deleteTitle: String = "삭제하기"
    }

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

    private lazy var reviseView: UIView = generateOptionView(
        icon: UIImage(named: "reviseIcon"),
        title: Constant.reviseTitle
    )

    private lazy var deleteView: UIView = generateOptionView(
        icon: UIImage(named: "deleteIcon"),
        title: Constant.deleteTitle
    )

    //MARK: - Life Cycle

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

    func configureUI() {
        let defaultHeigh: CGFloat = 176
        [reviseView, dividingLineView, deleteView].forEach {
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

        reviseView.snp.makeConstraints {
            $0.height.equalTo(deleteView.snp.height)
        }
    }
}

//MARK: - Private
private extension OptionModalViewController {
    func generateOptionView(icon: UIImage?, title: String) -> UIView {
        //ui
        let view = UIView()
        let iconView = UIImageView(image: icon)

        let label = UILabel()
        label.textColor = .gray100
        label.text = title
        label.font = .pretendard(size: 16, weightName: .medium)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4

        // configure Layout
        [iconView, label].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)

        iconView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        return view
    }

    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.1) {
            self.dimmedView.alpha = 0
        }
        self.dismiss(animated: true)
    }
}
