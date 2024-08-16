//
//  GuideDetailView.swift
//  StreetDrop
//
//  Created by jihye kim on 13/08/2024.
//

import UIKit

class GuideDetailView: UIView {
    private lazy var speechBubblePointImageView: UIImageView = {
        let speechBubblePointImage = UIImage(named: "speechBubblePoint")
        let imageView = UIImageView(image: speechBubblePointImage)

        return imageView
    }()

    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 12, weightName: .medium)
        label.numberOfLines = 0
        label.textColor = .gray200

        return label
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    func configureText(_ text: String) {
        guideLabel.text = text
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GuideDetailView {
    func configureUI() {
        self.backgroundColor = .gray600
        self.layer.cornerRadius = 12
        self.alpha = 0
        self.isUserInteractionEnabled = false
        
        [speechBubblePointImageView, guideLabel].forEach {
            addSubview($0)
        }

        speechBubblePointImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(self.snp.top)
            $0.width.equalTo(10)
            $0.height.equalTo(8)
        }

        guideLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
        }
    }
}
