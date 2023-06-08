//
//  SearchingMusicTableViewCell.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/21.
//

import UIKit

import SnapKit

class SearchingMusicTableViewCell: UITableViewCell {
    static let identifier = "SearchingMusicTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(music: Music) {
        if let url = URL(string: music.albumImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.albumImage.image = UIImage(data: data ?? Data())
                }
            }
        }
        
        self.songNameLabel.text = music.songName
        self.artistNameLabel.text = music.artistName
        self.durationTimeLabel.text = music.durationTime
    }
    
    // MARK: - UI
    
    private lazy var albumImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 16, weight: 600)
        label.setLineHeight(lineHeight: 24)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 12, weight: 600)
        label.setLineHeight(lineHeight: 18)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.821, green: 0.834, blue: 0.879, alpha: 1)
        return label
    }()
    
    private lazy var durationTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 13, weight: 400)
        label.setLineHeight(lineHeight: 17)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.82, green: 0.835, blue: 0.878, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}

private extension SearchingMusicTableViewCell {
    func configureUI() {
        [
            self.albumImage,
            self.songNameLabel,
            self.artistNameLabel,
            self.durationTimeLabel
        ].forEach {
            self.addSubview($0)
        }
        
        self.albumImage.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        
        self.songNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.albumImage.snp.top)
            $0.leading.equalTo(self.albumImage.snp.trailing).offset(12)
            $0.trailing.equalTo(self.durationTimeLabel.snp.leading).offset(-30)
        }
        
        self.artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.songNameLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(22)
            $0.leading.equalTo(self.albumImage.snp.trailing).offset(12)
            $0.trailing.equalTo(self.durationTimeLabel.snp.leading).offset(-30)
        }
        
        self.durationTimeLabel.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(17)
            $0.bottom.equalTo(self.artistNameLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
