//
//  RecommendArtistCell.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import UIKit

import Kingfisher

class RecommendArtistCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private lazy var imageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 12, weightName: .semiBold)
        label.setLineHeight(lineHeight: 16)
        label.textColor = .white
        label.numberOfLines = 1
        
        return label
    }()
    
    func configure(with item: Artist) {
        nameLabel.text = item.name
        
        if let artistImageUrl = URL(string: item.image) {
            imageView.kf.setImage(with: artistImageUrl)
        }
    }
}

private extension RecommendArtistCell {
    func configureUI() {
        self.contentView.backgroundColor = .gray600
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.contentView.layer.masksToBounds = true
        
        [
            self.imageView,
            self.nameLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        self.imageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalTo(self.imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
