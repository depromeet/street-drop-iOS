//
//  RecommendMusicCell.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import UIKit

import Kingfisher

class RecommendMusicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private lazy var albumCoverImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 12, weightName: .regular)
        label.setLineHeight(lineHeight: 16)
        label.textColor = .gray200
        label.numberOfLines = 1
        
        return label
    }()
    
    func configure(with item: Music) {
        titleLabel.text = item.songName
        artistLabel.text = item.artistName
        
        if let albumImageUrl = URL(string: item.albumThumbnailImage) {
            albumCoverImageView.kf.setImage(with: albumImageUrl)
        }
    }
}

private extension RecommendMusicCell {
    func configureUI() {
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        
        [
            self.albumCoverImageView,
            infoStackView
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        [
            self.titleLabel,
            self.artistLabel
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        self.albumCoverImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(albumCoverImageView.snp.trailing).offset(8)
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.centerY.trailing.equalToSuperview()
        }
    }
}
