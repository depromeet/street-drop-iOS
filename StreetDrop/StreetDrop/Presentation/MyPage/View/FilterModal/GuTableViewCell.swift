//
//  GuTableViewCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 12/20/24.
//

import UIKit

import SnapKit

final class GuTableViewCell: UITableViewCell {
    static let identifier = "GuTableViewCell"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        label.font = .pretendard(size: 16, weightName: .medium)
        label.textColor = .gray400
        label.numberOfLines = 1
        label.setLineHeight(lineHeight: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    func configure(regionName: String) {
        nameLabel.text = regionName
    }
}

private extension GuTableViewCell {
    func configureUI() {
        backgroundColor = .gray600
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

