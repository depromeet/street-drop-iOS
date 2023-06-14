//
//  RecentQueryButton.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/25.
//

import UIKit

import RxRelay

final class RecentQueryButton: UIControl {
    var query: String {
        get {
            return self.queryLabel.text ?? ""
        }
        
        set {
            self.queryLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 1)
        self.layer.cornerRadius = 16
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var queryLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 16.71)
        label.textColor = UIColor.gray150
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var deletingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deletingQuery"), for: .normal)
        return button
    }()

    private func configureUI() {
        [
            self.queryLabel,
            self.deletingButton
        ].forEach {
            self.addSubview($0)
        }
        
        self.queryLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(12)
        }
        
        self.deletingButton.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.top.bottom.equalToSuperview().inset(12.5)
            $0.leading.equalTo(self.queryLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}
