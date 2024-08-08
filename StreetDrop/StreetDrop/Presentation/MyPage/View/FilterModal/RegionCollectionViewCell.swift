//
//  RegionCollectionViewCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/5/24.
//

import UIKit

import SnapKit

final class RegionCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
    private lazy var regionNameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 16, weightName: .medium)
        label.setLineHeight(lineHeight: 24)
        label.textColor = .gray200
        label.numberOfLines = 1
        label.textAlignment = .center
        
        return label
    }()
    
    func configure(regionName: String) {
        regionNameLabel.text = regionName
    }
}

private extension RegionCollectionViewCell {
    func configureUI() {
        self.backgroundColor = .gray600
        
        addSubview(regionNameLabel)
        
        regionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
