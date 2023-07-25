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

final class MusicTableViewCell: UITableViewCell {
    static let identifier = "MusicTableViewCell"
    private var disposeBag: DisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(item: MyMusic) {
        self.albumCoverImageView.setImage(
            with: item.albumImageURL,
            isImageFromAppleServer: true,
            disposeBag: disposeBag
        )
        self.musicTitleLabel.text = item.song
        self.singerNameLabel.text = item.singer
        self.commentLabel.text = item.comment
        self.locationLabel.text = item.location
        self.likeLabel.text = String(item.likeCount)
    }
    
    // MARK: - UI
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var musicSingerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "음악 이름"
        label.textColor = .white
        label.font = .pretendard(size: 14, weightName: .bold)
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "가수 이름"
        label.textColor = .gray200
        label.font = .pretendard(size: 14, weightName: .regular)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "코멘트"
        label.textColor = .gray100
        label.font = .pretendard(size: 16, weightName: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var locaitonLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
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
    
    private lazy var likeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "likeFillIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.darkPrimary_75
        return imageView
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.darkPrimary_75
        label.font = .pretendard(size: 12, weightName: .regular)
        return label
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.gray700
        return view
    }()
}

private extension MusicTableViewCell {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Cell
        
        self.backgroundColor = UIColor.gray900
        self.selectionStyle = .none
        
        // MARK: - Container StackView
        
        self.addSubview(self.containerStackView)
        self.containerStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Album Cover ImageView
        
        self.containerStackView.addArrangedSubview(albumCoverImageView)
        self.albumCoverImageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
        
        // MARK: - Info StackView
        
        self.containerStackView.addArrangedSubview(infoStackView)
        
        // MARK: - Music Singer StackView
        
        self.infoStackView.addArrangedSubview(musicSingerStackView)
        self.musicSingerStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        // MARK: - Muisc Title Label
        
        self.musicSingerStackView.addArrangedSubview(musicTitleLabel)
        
        // MARK: - Singer Name Label
        
        self.musicSingerStackView.addArrangedSubview(singerNameLabel)
        
        self.musicSingerStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                return spacerView
            }()
        )
        
        self.musicSingerStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.backgroundColor = UIColor.clear
                return spacerView
            }()
        )
        
        // MARK: - Comment Label
        
        self.infoStackView.addArrangedSubview(commentLabel)
        
        // MARK: - Location Like StackView
        
        self.infoStackView.addArrangedSubview(locaitonLikeStackView)
        self.locaitonLikeStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        // MARK: - Location Icon ImageView
        
        self.locaitonLikeStackView.addArrangedSubview(locationIconImageView)
        self.locationIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        
        // MARK: - Location Label
        
        self.locaitonLikeStackView.addArrangedSubview(locationLabel)
        
        // MARK: - Like Icon ImageView
        
        self.locaitonLikeStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 8).isActive = true
                return spacerView
            }()
        )
        self.locaitonLikeStackView.addArrangedSubview(likeIconImageView)
        self.likeIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        
        // MARK: - Like Label
        
        self.locaitonLikeStackView.addArrangedSubview(likeLabel)
        
        self.locaitonLikeStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                return spacerView
            }()
        )
        
        self.locaitonLikeStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.backgroundColor = UIColor.clear
                return spacerView
            }()
        )
        
        // MARK: - Separator View
        
        self.addSubview(separatorView)
        self.separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
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

@available(iOS 13.0.0, *)
struct MusicTableViewCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            return MusicTableViewCell()
        }
        .previewLayout(.fixed(width: 327, height: 92))
    }
}
