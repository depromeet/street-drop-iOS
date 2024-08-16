//
//  RecentSearchesHeaderView.swift
//  StreetDrop
//
//  Created by jihye kim on 12/08/2024.
//

import UIKit

import SnapKit

class RecentSearchesHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        titleLabel.font = .pretendard(size: 14, weightName: .medium)
        titleLabel.textColor = .gray150
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
