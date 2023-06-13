//
//  DroppedMusicWithinAreaCollectionViewCell.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/05/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class DroppedMusicWithinAreaCollectionViewCell: UICollectionViewCell {
    static let identifier = "DroppedMusicWithinAreaCollectionViewCell"
    private let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(item: MusicWithinAreaEntity) {
        self.musicTitleLabel.text = item.musicTitle
        self.singerNameLabel.text = item.artist
        self.albumCoverImageView.setImage(with: item.albumImageURL, disposeBag: disposeBag)
    }
    
    // MARK: - UI
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
}

// MARK: - Private Functions

private extension DroppedMusicWithinAreaCollectionViewCell {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Singer Name Label
        
        self.addSubview(self.singerNameLabel)
        self.singerNameLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        // MARK: - Music Title Label
        
        self.addSubview(self.musicTitleLabel)
        self.musicTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.singerNameLabel.snp.top)
        }
        
        // MARK: - Album Cover ImageView
        
        self.addSubview(self.albumCoverImageView)
        self.albumCoverImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.musicTitleLabel.snp.top).inset(-12)
            make.width.height.equalTo(84)
        }
    }
}
