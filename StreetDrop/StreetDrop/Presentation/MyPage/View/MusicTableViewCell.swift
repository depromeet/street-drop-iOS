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
    
    // MARK: - UI
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var musicSingerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .blue
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var musicTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "음악 이름"
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "가수 이름"
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "코멘트 테스트 테스트"
        return label
    }()
    
    private lazy var locaitonLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.backgroundColor = .yellow
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "XXX구 XXX동"
        return label
    }()
    
    private lazy var likeIconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "OOO개"
        return label
    }()
}

private extension MusicTableViewCell {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Container StackView
        
        self.addSubview(self.containerStackView)
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
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
        
        // MARK: - Muisc Title Label
        
        self.musicSingerStackView.addArrangedSubview(musicTitleLabel)
        
        // MARK: - Singer Name Label
        
        self.musicSingerStackView.addArrangedSubview(singerNameLabel)
        
        // MARK: - Comment Label
        
        self.infoStackView.addArrangedSubview(commentLabel)
        
        // MARK: - Location Like StackView
        
        self.infoStackView.addArrangedSubview(locaitonLikeStackView)
        
        // MARK: - Location Icon ImageView
        
        self.locaitonLikeStackView.addArrangedSubview(locationIconImageView)
        self.locationIconImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
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
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        // MARK: - Like Label
        
        self.locaitonLikeStackView.addArrangedSubview(likeLabel)
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
