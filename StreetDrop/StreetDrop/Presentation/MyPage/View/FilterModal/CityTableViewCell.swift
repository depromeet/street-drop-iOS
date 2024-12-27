//
//  CityTableViewCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 8/5/24.
//

import UIKit

import SnapKit

final class CityTableViewCell: UITableViewCell {
    static let identifier = "StateTableViewCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? .gray800 : .gray900
        nameLabel.textColor = selected ? .textPrimary : .gray400
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 16, weight: 500)
        label.numberOfLines = 1
        label.textColor = .gray400
        label.setLineHeight(lineHeight: 24)
        
        return label
    }()
    
    private let countLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 16, weightName: .medium)
        label.numberOfLines = 1
        label.textColor = .textPrimary
        label.setLineHeight(lineHeight: 24)
        
        return label
    }()
    
    private let bottomView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        
        return view
    }()
    
    func configure(regionName: String) {
        nameLabel.text = regionName
    }
}

private extension CityTableViewCell {
    func configureUI() {
        contentView.backgroundColor = .gray900
        
        [
            nameLabel,
            bottomView
        ].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
