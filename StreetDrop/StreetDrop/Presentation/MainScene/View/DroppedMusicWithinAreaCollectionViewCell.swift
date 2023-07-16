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
        self.sideCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumCoverImageView.image = nil
        self.sideCell()
        self.disposeBag = DisposeBag()
    }
    
    func setData(item: MusicWithinAreaEntity) {
        self.musicTitleLabel.text = item.musicTitle
        self.singerNameLabel.text = item.artist
        self.albumCoverImageView.setImage(with: item.albumImageURL, disposeBag: disposeBag)
        self.commentLabel.text = item.content
    }
    
    // MARK: - UI
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weightName: .bold)
        label.textColor = UIColor.gray50
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 12, weightName: .semiBold)
        label.textColor = UIColor.gray150
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var commentContainerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.primary300.cgColor
        view.layer.cornerRadius = 12
        
        view.layer.shadowColor = UIColor.primary500.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10

        view.isUserInteractionEnabled = true
        view.isHidden = true
        return view
    }()
    
    private lazy var commentContainerTailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "commentTail")
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.gray900
        label.isHidden = true
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width / 3
        return label
    }()
}

extension DroppedMusicWithinAreaCollectionViewCell {
    
    func middleCell(completion: (() -> Void)? = nil) {
        self.singerNameLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(20)
        }
        
        self.albumCoverImageView.snp.updateConstraints { make in
            make.width.height.equalTo(84)
        }
        
        albumCoverImageView.layer.borderWidth = 2
        musicTitleLabel.font = .pretendard(size: 16, weight: 700)
        
        albumCoverImageView.alpha = 1
        musicTitleLabel.alpha = 1
        singerNameLabel.alpha = 1
        
        self.isUserInteractionEnabled = true
        
        middleComment()
        if let completion = completion {
            completion()
        }
    }
    
    func sideCell(completion: (() -> Void)? = nil) {
        self.singerNameLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        self.albumCoverImageView.snp.updateConstraints { make in
            make.width.height.equalTo(56)
        }
        
        albumCoverImageView.layer.borderWidth = 0
        musicTitleLabel.font = .pretendard(size: 14, weight: 700)
        
        albumCoverImageView.alpha = 0.5
        musicTitleLabel.alpha = 0.5
        singerNameLabel.alpha = 0.5
        
        self.isUserInteractionEnabled = false
        
        sideComment()
        if let completion = completion {
            completion()
        }
    }
    
    func middleComment() {
        commentLabel.isHidden = false
        commentContainerView.isHidden = false
        commentContainerTailImageView.isHidden = false
    }
    
    func sideComment() {
        commentLabel.isHidden = true
        commentContainerView.isHidden = true
        commentContainerTailImageView.isHidden = true
    }
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - View
        
        self.isUserInteractionEnabled = false
        
        // MARK: - Singer Name Label
        
        self.addSubview(self.singerNameLabel)
        self.singerNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(20)
        }
        
        // MARK: - Music Title Label
        
        self.addSubview(self.musicTitleLabel)
        self.musicTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.singerNameLabel.snp.top)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(5)
        }
        
        // MARK: - Album Cover ImageView
        
        self.addSubview(self.albumCoverImageView)
        self.albumCoverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.musicTitleLabel.snp.top).offset(-12)
            make.width.height.equalTo(84)
        }
        
        // MARK: - Comment Label
        
        self.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.albumCoverImageView.snp.top).offset(-30)
        }
        
        // MARK: - Comment Container View
        
        self.addSubview(self.commentContainerView)
        self.commentContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.commentLabel.snp.top).inset(-12)
            make.bottom.equalTo(self.albumCoverImageView.snp.top).offset(-18)
            make.left.equalTo(self.commentLabel.snp.left).inset(-16)
            make.right.equalTo(self.commentLabel.snp.right).inset(-16)
        }
        self.sendSubviewToBack(commentContainerView)
        
        // MARK: - Comment Container Tail ImageView
        
        self.addSubview(self.commentContainerTailImageView)
        self.commentContainerTailImageView.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.commentContainerView.snp.bottom).offset(6)
        }
    }
}
