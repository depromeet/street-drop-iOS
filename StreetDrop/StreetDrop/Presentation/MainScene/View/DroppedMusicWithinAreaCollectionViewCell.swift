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
    
    private let musicTitleLabel: UILabel = {
        let musicTitleLabel = UILabel()
        musicTitleLabel.font = .systemFont(ofSize: 14)
        musicTitleLabel.textColor = .white
        musicTitleLabel.numberOfLines = 1
        musicTitleLabel.textAlignment = .center
        return musicTitleLabel
    }()
    private let singerNameLabel: UILabel = {
        let singerNameLabel = UILabel()
        singerNameLabel.font = .systemFont(ofSize: 14)
        singerNameLabel.textColor = .white
        singerNameLabel.numberOfLines = 1
        singerNameLabel.textAlignment = .center
        return singerNameLabel
    }()
    private let albumCoverButton: UIButton = {
        let albumCoverButton = UIButton()
        albumCoverButton.backgroundColor = .gray
        albumCoverButton.isUserInteractionEnabled = true
        return albumCoverButton
    }()
    private let commentContainerImageView: UIImageView = {
        let commentContainerImageView = UIImageView()
        commentContainerImageView.backgroundColor = .clear
        commentContainerImageView.image = UIImage(named: "commentContainer.png")
        commentContainerImageView.isUserInteractionEnabled = true
        commentContainerImageView.contentMode = .scaleToFill
        return commentContainerImageView
    }()
    private let commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.textColor = .black
        commentLabel.numberOfLines = 2
        commentLabel.textAlignment = .center
        return commentLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(musicTitle: String, singerName: String, comment: String) {
        self.musicTitleLabel.text = musicTitle
        self.singerNameLabel.text = singerName
        self.commentLabel.text = comment
    }
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
        
        // MARK: - Album Cover Button
        
        self.addSubview(self.albumCoverButton)
        self.albumCoverButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.musicTitleLabel.snp.top).inset(-12)
            make.width.height.equalTo(84)
        }
        
        // MARK: - Comment Container ImageView
        
        self.addSubview(self.commentContainerImageView)
        self.commentContainerImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.albumCoverButton.snp.top).inset(-12)
        }
        
        // MARK: - Comment Label
        
        self.commentContainerImageView.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
