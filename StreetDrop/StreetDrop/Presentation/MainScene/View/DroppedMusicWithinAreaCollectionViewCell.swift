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
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumCoverImageView.image = nil
        self.disposeBag = DisposeBag()
    }
    
    func setData(item: MusicWithinAreaEntity) {
        self.musicTitleLabel.text = item.musicTitle
        self.singerNameLabel.text = item.artist
        self.albumCoverImageView.setImage(with: item.albumImageURL, disposeBag: disposeBag)
        self.commentLabel.text = item.content
    }
    
    func setComment(isPresented: Bool) {
        self.commentContainerImageView.isHidden = !isPresented
        self.commentLabel.isHidden = !isPresented
    }
    
    // MARK: - UI
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: 700)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 12, weight: 600)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor(red: 0.9, green: 0.997, blue: 1, alpha: 1).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var commentContainerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comment")
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
}

// MARK: - Private Functions

private extension DroppedMusicWithinAreaCollectionViewCell {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Comment Container ImageView
        
        self.addSubview(self.commentContainerImageView)
        self.commentContainerImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.left.right.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
        
        // MARK: - Comment Label
        
        self.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(commentContainerImageView).inset(16)
            make.top.equalTo(commentContainerImageView).inset(12)
            make.bottom.equalTo(commentContainerImageView).inset(18)
        }
        
        // MARK: - Album Cover ImageView
        
        self.addSubview(self.albumCoverImageView)
        self.albumCoverImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.commentContainerImageView.snp.bottom).offset(12)
            make.width.height.equalTo(84)
        }
        
        // MARK: - Music Title Label
        
        self.addSubview(self.musicTitleLabel)
        self.musicTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.albumCoverImageView.snp.bottom).offset(12)
        }
        
        // MARK: - Singer Name Label
        
        self.addSubview(self.singerNameLabel)
        self.singerNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.musicTitleLabel.snp.bottom)
        }
    }
}
