//
//  DropDoneView.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/19/24.
//

import UIKit

import RxSwift
import RxRelay
import Kingfisher
import SnapKit

final class DropDoneView: UIView {
    // View -> ViewController
    private let exitButtonEventRelay: PublishRelay<Void> = .init()
    var exitButtonEvent: Observable<Void> {
        exitButtonEventRelay.asObservable()
    }
    private let viewOnAppButtonEventRelay: PublishRelay<Void> = .init()
    var viewOnAppButtonEvent: Observable<Void> {
        viewOnAppButtonEventRelay.asObservable()
    }
    
    private let droppedMusic: Music
    private let droppedAddress: String
    private let droppedComment: String
    private let disposeBag: DisposeBag = .init()
    
    init(
        droppedMusic: Music,
        droppedAddress: String,
        droppedComment: String
    ) {
        self.droppedMusic = droppedMusic
        self.droppedAddress = droppedAddress
        self.droppedComment = droppedComment
        super.init(frame: .zero)
        bindAction()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dropDoneTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "드랍 완료!"
        label.font = .pretendard(size: 18, weight: 700)
        label.textColor = .white
        label.setLineHeight(lineHeight: 28)
        
        return label
    }()
    
    private let exitButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(named: "exit"), for: .normal)
        
        return button
    }()
    
    private let contentContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var albumImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.05).cgColor
        imageView.layer.masksToBounds = true
        
        imageView.kf.setImage(with: URL(string: droppedMusic.albumImage))
        
        return imageView
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = droppedMusic.songName
        label.font = .pretendard(size: 14, weight: 500)
        label.textColor = .white
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = droppedMusic.artistName
        label.textColor = .gray200
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16)
        
        return label
    }()
    
    private let middleLine: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray600
        
        return view
    }()
    
    private lazy var commentLabel: UILabel = {
        let label: UILabel = .init()
        label.text = droppedComment
        label.font = .pretendard(size: 14, weight: 400)
        label.textColor = .white
        label.numberOfLines = 0
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private let locationImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "share-extension-location"))
        
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label: UILabel = .init()
        label.text = droppedAddress
        label.font = .pretendard(size: 12, weight: 400)
        label.textColor = .primary400
        label.setLineHeight(lineHeight: 16)
        
        return label
    }()
    
    private let viewOnAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("앱에서 보기", for: .normal)
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: 700)
        button.layer.cornerRadius = 12
        button.backgroundColor = .primary400

        return button
    }()
}

private extension DropDoneView {
    func bindAction() {
        exitButton.rx.tap
            .bind(to: exitButtonEventRelay)
            .disposed(by: disposeBag)
        
        viewOnAppButton.rx.tap
            .bind(to: viewOnAppButtonEventRelay)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray600.cgColor
        backgroundColor = .gray800
        
        [
            dropDoneTitleLabel,
            exitButton,
            contentContainerView,
            viewOnAppButton
        ].forEach {
            addSubview($0)
        }
        
        [
            albumImageView,
            songNameLabel,
            artistNameLabel,
            middleLine,
            commentLabel,
            locationImageView,
            addressLabel
        ].forEach {
            contentContainerView.addSubview($0)
        }
        
        dropDoneTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }
        
        exitButton.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(32)
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        var contentContainerViewHeightConstraint: Constraint?
        contentContainerView.snp.makeConstraints {
            contentContainerViewHeightConstraint = $0.height.equalTo(0).constraint
            $0.top.equalTo(dropDoneTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    
        albumImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        songNameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(8)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(songNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(8)
        }
        
        middleLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(albumImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(middleLine.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        locationImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(commentLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(locationImageView)
            $0.leading.equalTo(locationImageView.snp.trailing)
        }
        
        viewOnAppButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
        }
        
        layoutIfNeeded()
        
        let contentContainerHeight = 16 + 48 + 33 + commentLabel.actualNumberOfLines() * 20 + 46
        contentContainerViewHeightConstraint?.update(
            offset: contentContainerHeight
        )
        
        snp.makeConstraints {
            $0.height.equalTo(60 + contentContainerHeight + 132)
        }
    }
}
