//
//  MusicListSectionHeaderView.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/19.
//

import UIKit

import SnapKit

final class MusicListSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MusicListSectionHeaderView"
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray200
        label.font = .pretendard(size: 12, weightName: .regular)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(date: String) {
        self.dateLabel.text = date
    }
}

extension MusicListSectionHeaderView {
    // MARK: - UI
    
    func configureUI() {
        backgroundColor = UIColor.gray900
        
        // MARK: - Date Label
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
    }
}
