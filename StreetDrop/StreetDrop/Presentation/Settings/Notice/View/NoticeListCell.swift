//
//  NoticeListCell.swift
//  StreetDrop
//
//  Created by jihye kim on 15/06/2024.
//

import UIKit

import SnapKit

class NoticeListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 16, weightName: .medium)
        label.setLineHeight(lineHeight: 24)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 12, weightName: .regular)
        label.setLineHeight(lineHeight: 16)
        label.textColor = .gray200
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var bottomLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .gray700
        
        return view
    }()
    
    func configure(with item: Notice) {
        titleLabel.text = item.title
        createdAtLabel.text = item.createdAt
    }
}

private extension NoticeListCell {
    func configureUI() {
        self.backgroundColor = .gray900
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        
        [
            stackView,
            self.bottomLineView
        ].forEach {
            self.addSubview($0)
        }
        
        [
            self.titleLabel,
            self.createdAtLabel,
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.bottomLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(20)
        }
    }
}
