//
//  RecentQueryCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/25.
//

import UIKit

import RxRelay
import RxSwift

final class RecentQueryCell: UICollectionViewCell {
    var query: String {
        self.queryLabel.text ?? ""
    }
    
    private var deletingButtonTappedEvent: PublishRelay<String>?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray600
        self.layer.cornerRadius = frame.height / 2
        self.configureUI()
        self.bindAction()
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
        button.setImage(
            // TODO: jihye - figma image update
            UIImage(named: "deletingQuery")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .gray400
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
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().inset(10)
        }
        
        self.deletingButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.equalTo(self.queryLabel)
            $0.leading.equalTo(self.queryLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(6)
        }
    }
    
    private func bindAction() {
        deletingButton.rx.tap
            .bind { [weak self] in
                guard let self,
                      let query = self.queryLabel.text
                else { return }
                
                self.deletingButtonTappedEvent?.accept(query)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(
        with query: String,
        deletingButtonTappedEvent: PublishRelay<String>
    ) {
        self.queryLabel.text = query
        self.deletingButtonTappedEvent = deletingButtonTappedEvent
    }
}
