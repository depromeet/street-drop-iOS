//
//  MusicTableViewCell.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/01.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class MusicListCell: UITableViewCell {
    static let identifier = "MusicListCell"
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLikeViewCornerRadius()
    }
    
    func setData(item: MyMusic) {
        albumCoverImageView.setImage(with: item.albumImageURL)
        self.musicTitleLabel.text = item.song
        self.singerNameLabel.text = item.singer
        self.commentLabel.text = item.comment
        self.locationLabel.text = item.location
        self.likeLabel.text = String(item.likeCount)
        self.userNameLabel.text = item.userName
        /*
         TODO:
         - 백엔드 개발 완료 후 내가 좋아요한 뮤직 노출 처리
         */
//                likeIconImageView.tintColor = .primary400
//                likeIconImageView.image = UIImage(named: "icon-heart-fill")?.withRenderingMode(.alwaysTemplate)
        
        layoutIfNeeded()
    }
    
    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "유저"
        label.textColor = .white
        label.font = .pretendard(size: 14, weightName: .medium)
        return label
    }()
    
    private lazy var locationTimeAgoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationBasicIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.darkPrimary_75
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "XXX구 XXX동"
        label.textColor = UIColor.darkPrimary_75
        label.font = .pretendard(size: 12, weightName: .regular)
        return label
    }()
    
    private lazy var timeAgoLabel: UILabel = {
        let label = UILabel()
        label.text = "1초 전"
        label.textColor = .gray200
        label.font = .pretendard(size: 12, weightName: .regular)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "코멘트"
        label.textColor = .gray100
        label.font = .pretendard(size: 14, weightName: .regular)
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray200
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "음악 이름"
        label.textColor = .white
        label.font = .pretendard(size: 12, weightName: .semiBold)
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "가수 이름"
        label.textColor = .gray200
        label.font = .pretendard(size: 12, weightName: .semiBold)
        return label
    }()
    
    private lazy var likeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.gray400.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private lazy var likeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-heart-empty")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray400
        return imageView
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = .pretendard(size: 12, weightName: .regular)
        return label
    }()
}

// MARK: - Private Methods

private extension MusicListCell {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Cell
        
        self.backgroundColor = UIColor.gray900
        self.selectionStyle = .none
        
        // MARK: - Root View
        let rootView = UIView()
        rootView.backgroundColor = .gray800
        rootView.roundCorners(.allCorners, radius: 20)
        
        contentView.addSubview(rootView)
        rootView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualToSuperview().inset(8).priority(.high)
        }
        
        // MARK: - Container View
        
        rootView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // MARK: - User Name Label
        
        containerView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        // MARK: - Location TimeAgo StackView
        
        containerView.addSubview(locationTimeAgoStackView)
        locationTimeAgoStackView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        let dotLabel = UILabel()
        dotLabel.text = "·"
        dotLabel.textColor = .gray200
        dotLabel.textAlignment = .center
        
        [
            locationIconImageView,
            locationLabel,
            dotLabel,
            timeAgoLabel
        ]
            .forEach { view in
                locationTimeAgoStackView.addArrangedSubview(view)
            }
        
        // MARK: - Comment Label
        
        containerView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(locationTimeAgoStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        // MARK: - Separator View
        
        let separatorView = UIView()
        separatorView.backgroundColor = .gray600
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        // MARK: - Bottom Content View
        
        let bottomContentView = UIView()
        bottomContentView.backgroundColor = .clear
        
        containerView.addSubview(bottomContentView)
        bottomContentView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        // MARK: - Album Cover Image View
        
        bottomContentView.addSubview(albumCoverImageView)
        albumCoverImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(42)
        }
        
        // MARK: - Muisc Singer View
        
        let musicSingerView = UIView()
        musicSingerView.backgroundColor = .clear
        
        bottomContentView.addSubview(musicSingerView)
        musicSingerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(albumCoverImageView.snp.trailing).offset(16)
        }
        
        // MARK: - Music Title Label
        
        musicSingerView.addSubview(musicTitleLabel)
        musicTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.trailing.equalToSuperview()
        }
        
        // MARK: - Singer Name Label
        
        musicSingerView.addSubview(singerNameLabel)
        singerNameLabel.snp.makeConstraints {
            $0.top.equalTo(musicTitleLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7)
        }
                
        // MARK: - Like Stack View
        
        bottomContentView.addSubview(likeView)
        likeView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.greaterThanOrEqualTo(musicSingerView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        likeView.addSubview(likeIconImageView)
        likeIconImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(4)
            $0.width.equalTo(20)
        }
        
        likeView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.equalTo(likeIconImageView.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
    
    func updateLikeViewCornerRadius() {
        let labelSize = likeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: likeView.bounds.height))
        let viewHeight = likeView.bounds.height
        let cornerRadius = min(viewHeight, labelSize.width + 24) / 2
        likeView.roundCorners(.allCorners, radius: cornerRadius)
    }
}

//MARK: - for canvas
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
