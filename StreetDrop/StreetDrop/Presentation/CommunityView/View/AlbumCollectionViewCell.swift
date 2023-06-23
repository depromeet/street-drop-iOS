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

    private func configureHierarchy() {
        self.contentView.addSubview(albumImageView)
    }

    private func configureLayout() {
        albumImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview().multipliedBy(0.8)
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func layout() {
        configureHierarchy()
        configureLayout()
    }

    func setData(_ albumImageURL: String) {
        guard !albumImageURL.isEmpty  else {
            return
        }

        self.albumImageView.setImage(with: albumImageURL, disposeBag: disposeBag)
    }

    override func prepareForReuse() {
      super.prepareForReuse()
        self.albumImageView.image = nil
    }
}
