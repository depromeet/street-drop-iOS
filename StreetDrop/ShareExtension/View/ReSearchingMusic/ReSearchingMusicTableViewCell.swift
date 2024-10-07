//
//  ReSearchingMusicTableViewCell.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Kingfisher

final class ReSearchingMusicTableViewCell: UITableViewCell {
    static let identifier = "SearchingMusicTableViewCell"
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumImageView.image = nil
        self.disposeBag = DisposeBag()
    }
    
    func setData(music: Music) {
        albumImageView.setImage(with: music.albumImage)
        songNameLabel.text = music.songName
        artistNameLabel.text = music.artistName
        durationTimeLabel.text = music.durationTime
    }
    
    private lazy var albumImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.layer.cornerRadius = 12.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 16, weight: 600)
        label.setLineHeight(lineHeight: 24)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16)
        label.numberOfLines = 1
        label.textColor = UIColor.gray200
        return label
    }()
    
    private lazy var durationTimeLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16)
        label.numberOfLines = 1
        label.textColor = UIColor.gray200
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
}

private extension ReSearchingMusicTableViewCell {
    func configureUI() {
        [
            albumImageView,
            songNameLabel,
            artistNameLabel,
            durationTimeLabel
        ].forEach {
            addSubview($0)
        }
        
        albumImageView.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        songNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(60)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(songNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(durationTimeLabel.snp.leading)
        }
        
        durationTimeLabel.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(16)
            $0.bottom.equalTo(artistNameLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}

