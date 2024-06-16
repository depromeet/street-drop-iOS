//
//  SettingElementCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxRelay
import SnapKit

class SettingElementCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private lazy var InfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .gray100
        label.numberOfLines = 1
        
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(image: nil)
        
        return imageView
    }()
    
    private let newBadgeImageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(named: "newBadge"))
        imageView.isHidden = true
        return imageView
    }()
    
    func configure(
        with item: SettingItem,
        showNewBadge: Bool = false
    ) {
        InfoLabel.text = item.title
        iconImageView.image = item.iconImage
        newBadgeImageView.isHidden = !showNewBadge
    }
}

private extension SettingElementCell {
    func configureUI() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray800
        
        [
            self.InfoLabel,
            self.newBadgeImageView,
            self.iconImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.InfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        self.newBadgeImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.InfoLabel.snp.trailing).offset(4)
        }
        
        self.iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
