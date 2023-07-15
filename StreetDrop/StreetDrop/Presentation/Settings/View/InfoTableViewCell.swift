//
//  InfoTableViewCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import SnapKit

class InfoTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    
    private lazy var InfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 20)
        label.textColor = UIColor(red: 0.844, green: 0.881, blue: 0.933, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    func setData(text: String) {
        self.InfoLabel.text = text
    }
}

private extension InfoTableViewCell {
    func configureUI() {
        self.contentView.layer.cornerRadius = 12
        self.contentView.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        
        [
            self.InfoLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(4)
        }
        
        self.InfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
