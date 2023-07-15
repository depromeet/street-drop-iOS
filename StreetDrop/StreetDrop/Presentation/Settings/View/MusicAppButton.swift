//
//  MusicAppButton.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/15.
//

import UIKit

final class MusicAppButton: UIControl {
    var musicApp: MusicApp?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let musicAppLogo: UIImageView = {
        let imageView: UIImageView = .init()
        
        return imageView
    }()
    
    private let musicAppLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .white
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private let checkBoxImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = UIImage(named: "musicAppCheckBox")
        imageView.isHidden = true
        
        return imageView
    }()
    
    func setData(musicApp: MusicApp) {
        self.musicApp = musicApp
        musicAppLabel.text = musicApp.text
        musicAppLogo.image = UIImage(named: musicApp.imageName)
    }
    
    func setSelectedAppearance() {
        self.checkBoxImageView.isHidden = false
        self.backgroundColor = .darkPrimary_500_10
        self.layer.borderColor = UIColor.darkPrimary_500.cgColor
        self.layer.borderWidth = 1
    }
    
    func setUnselectedAppearance() {
        self.checkBoxImageView.isHidden = true
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.darkPrimary_500_10.cgColor
        self.layer.borderWidth = 1
    }
}

private extension MusicAppButton {
    func configureUI() {
        self.layer.cornerRadius = 12
        [
            self.musicAppLogo,
            self.musicAppLabel,
            self.checkBoxImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.musicAppLogo.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.trailing.equalTo(self.musicAppLabel.snp.leading)
        }
        
        self.musicAppLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.checkBoxImageView.snp.leading)
        }
        
        self.checkBoxImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
