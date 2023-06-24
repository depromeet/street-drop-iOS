//
//  CommunityGuideDetailView.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/25.
//

import UIKit

import RxSwift

class CommunityGuideDetailView: UIView {

    enum Constant {
        static let detailGuideText: String = "5자부터 40자까지 입력 가능합니다.\n욕설, 성희롱, 비방과 같은 내용은 삭제됩니다."
        static let detailGuideLinkButtonText: String = "가이드 바로가기"
    }

    let disposeBag: DisposeBag = DisposeBag()

    //MARK: - UI 요소

    private lazy var speechBubblePointImageView: UIImageView = {
        let speechBubblePointImage = UIImage(named: "speechBubblePoint")
        let imageView = UIImageView(image: speechBubblePointImage)

        return imageView
    }()

    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.detailGuideText
        label.font = .pretendard(size: 12, weightName: .medium)
        label.numberOfLines = 2
        label.textColor = .gray200

        return label
    }()

    private lazy var detailGuideLinkButton: UIButton = {
        let linkIcon = UIImage(named: "linkIcon")
        let button = UIButton()
        button.setImage(linkIcon, for: .normal)
        button.setTitle(Constant.detailGuideLinkButtonText, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .pretendard(size: 12, weightName: .semiBold)

        return button
    }()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)
        configureUI()
        bindAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CommunityGuideDetailView {

    // MARK: - Action Binding

    func bindAction() {
        detailGuideLinkButton.rx.tap
            .bind {
                guard let url = URL(
                    string: "https://unruly-case-46b.notion.site/4244aa9e3aff4977a2c076d2f1d78df8"
                ) else {
                    return
                }

                UIApplication.shared.open(url)
            }.disposed(by: disposeBag)
    }

    //MARK: - UI

    func configureUI() {
        backgroundColor = .gray600
        layer.cornerRadius = 12
        isHidden = true

        [speechBubblePointImageView, guideLabel, detailGuideLinkButton]
            .forEach {
                addSubview($0)
            }

        speechBubblePointImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalTo(self.snp.top)
            $0.width.equalTo(10)
            $0.height.equalTo(8)
        }

        guideLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.trailing.equalToSuperview().inset(12)
        }

        detailGuideLinkButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }

        detailGuideLinkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(guideLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
