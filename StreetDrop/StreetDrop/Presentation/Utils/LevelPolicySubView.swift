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
    
    // MARK: - UI
    
    fileprivate let levelImageView = UIImageView()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray700
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        addSubview(levelNameLabel)
        levelNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.equalTo(levelImageView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        addSubview(levelDescriptionLabel)
        levelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(levelNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(levelNameLabel)
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
            base.levelNameLabel.text = levelPolicy.levelName
            base.levelDescriptionLabel.text = levelPolicy.levelDescription
        }
    }
}
