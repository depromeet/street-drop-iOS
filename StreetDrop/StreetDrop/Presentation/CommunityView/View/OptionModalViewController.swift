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
        view.alpha = 0.25

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
}
