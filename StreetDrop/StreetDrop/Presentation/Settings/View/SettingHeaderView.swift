//
//  SettingHeaderView.swift
//  StreetDrop
//
//  Created by jihye kim on 15/06/2024.
//

import SnapKit
import UIKit

final class SettingHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        titleLabel.font = .pretendard(size: 14, weightName: .medium)
        titleLabel.textColor = .gray200

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
