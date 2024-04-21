//
//  LevelPolicySubView.swift
//  StreetDrop
//
//  Created by thoonk on 4/20/24.
//

import UIKit

import SnapKit
import RxSwift
import Kingfisher

final class LevelPolicySubView: UIView {
    
    // MARK: - Properties
    private var isGradient: Bool
    
    // MARK: - UI
    
    fileprivate let levelImageView = UIImageView()
    
    fileprivate let levelPrefixLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .bold)
        label.textColor = .darkPrimary_75
        
        return label
    }()
    
    fileprivate let levelNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weightName: .bold)
        label.textColor = .white
        
        return label
    }()
    
    fileprivate let levelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = .gray200
        
        return label
    }()
    
    // MARK: - Init
    
    init(isGradient: Bool) {
        self.isGradient = isGradient
        super.init(frame: .zero)
        
        backgroundColor = .gray700
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradientText()
    }
    
    // FIXME: Gradient 세부 조정 필요
    func setGradientText() {
        guard isGradient else { return }
        
        levelNameLabel.applyGradientWith(
            colors: [
                UIColor(hexString: "#B0C6FF"),
                UIColor(hexString: "#CBB3FF"),
                UIColor(hexString: "#71FFF6"),
                UIColor(hexString: "#F7F7F7"),
                UIColor(hexString: "#DCCCFF")
            ],
            locations: [
                0.1,
                0.25,
                0.56,
                0.74,
                0.89
            ]
        )
    }
}

// MARK: - Private Methods

private extension LevelPolicySubView {
    func configureUI() {
        addSubview(levelImageView)
        levelImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(56)
        }
        
        addSubview(levelPrefixLabel)
        levelPrefixLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(levelImageView.snp.trailing).offset(13)
            $0.width.equalTo(21)
            $0.height.equalTo(20)
        }
        
        addSubview(levelNameLabel)
        levelNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalTo(levelPrefixLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        addSubview(levelDescriptionLabel)
        levelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(levelNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(levelPrefixLabel)
            $0.trailing.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview().inset(6)
        }
    }
}

// MARK: - LevelPolicySubView + Rx

extension Reactive where Base: LevelPolicySubView {
    var setLevelPolicy: Binder<LevelPolicy> {
        Binder(base) { base, levelPolicy in
            base.levelImageView.kf.setImage(with: levelPolicy.levelImageURL)
            base.levelPrefixLabel.text = "L.\(levelPolicy.level)"
            base.levelNameLabel.text = levelPolicy.levelName
            base.levelDescriptionLabel.text = levelPolicy.levelDescription
            
            if levelPolicy.level == 2 {
                base.levelNameLabel.textColor = .darkPrimary_300
            }
        }
    }
}
