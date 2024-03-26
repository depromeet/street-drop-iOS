//
//  LevelUpGuideView.swift
//  StreetDrop
//
//  Created by thoonk on 2024/03/25.
//

import UIKit

final class LevelUpGuideView: UIView {
    
    private let remainDropGuideLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weightName: .medium)
        label.textColor = .white
        label.text = "음악을 1개 더 드랍하면 레벨업"
        
        return label
    }()
    
    private lazy var progressBar: GradientProgressBar = {
        let progressBar = GradientProgressBar()
        progressBar.gradientColors = [
            .pointGradient_1,
            .pointGradient_2,
            .pointGradient_3
        ]
        progressBar.roundCorners(.allCorners, radius: 5)
        
        return progressBar
    }()
    
    private let currentDropStateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = .gray400
        label.text = "4/5"
        
        return label
    }()
    
    private let tipLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        label.font = .pretendard(size: 12, weightName: .semiBold)
        label.textColor = .gray200
        label.backgroundColor = .gray600
        label.roundCorners(.allCorners, radius: 8)
        label.text = "Tip! 레벨업하면 음악을 들을 수 있는 반경이 넓어져요!"
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray800
        roundCorners(.allCorners, radius: 12)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.setProgress(0.8, animated: true)
    }
}

// MARK: - Private Methods

private extension LevelUpGuideView {
    func configureUI() {
        addSubview(remainDropGuideLabel)
        remainDropGuideLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.top.equalTo(remainDropGuideLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(215)
            $0.height.equalTo(10)
        }
        
        addSubview(currentDropStateLabel)
        currentDropStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.leading.equalTo(remainDropGuideLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(20)
            $0.top.equalTo(currentDropStateLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
}
