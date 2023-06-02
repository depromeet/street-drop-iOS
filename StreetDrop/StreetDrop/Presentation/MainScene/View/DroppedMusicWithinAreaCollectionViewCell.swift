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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(musicTitle: String, singerName: String) {
        self.musicTitleLabel.text = musicTitle
        self.singerNameLabel.text = singerName
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
    
    private lazy var albumCoverButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.isUserInteractionEnabled = true
        return button
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
        
        // MARK: - Album Cover Button
        
        self.addSubview(self.albumCoverButton)
        self.albumCoverButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.musicTitleLabel.snp.top).inset(-12)
            make.width.height.equalTo(84)
        }
    }
}
