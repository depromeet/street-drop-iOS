//
//  AlbumImageCollectionViewCell.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/24.
//

import UIKit

import RxSwift
import SnapKit

final class AlbumCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "AlbumCollectionViewCell"
    private let disposeBag: DisposeBag = DisposeBag()

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()   // TODO: 로딩이미지 추후 진행 (디자인팀과 희의O)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true

        return imageView
    }()

    private let gradationView: UIView = {
        let view = UIView()
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 0
//        view.layer.shadowOpacity = 1
//        view.layer.shadowColor = UIColor.primary500.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowRadius = 10
//        view.layer.masksToBounds = false

        return view
    }()

    private func configureHierarchy() {
        self.gradationView.addSubview(albumImageView)
        self.contentView.addSubview(gradationView)
    }

    private func configureLayout() {
        albumImageView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }

        gradationView.snp.makeConstraints {
            $0.width.height.equalToSuperview().multipliedBy(0.8)
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func layout() {
        configureHierarchy()
        configureLayout()
    }

    func setData(_ albumImageURL: String) {
        self.albumImageView.setImage(with: albumImageURL, disposeBag: disposeBag)
    }

    override func prepareForReuse() {
      super.prepareForReuse()
        self.albumImageView.image = nil
    }
}
