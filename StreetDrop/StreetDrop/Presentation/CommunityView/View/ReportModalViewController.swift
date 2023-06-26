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

    private enum Constant {
        static let title: String = "신고하기"
        static let reportGuideText: String = "신고 사유를 선택해 주세요"
        static let sendButtonTitle: String = "전송"
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
}
