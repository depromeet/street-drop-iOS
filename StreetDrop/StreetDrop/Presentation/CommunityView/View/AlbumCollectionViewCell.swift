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
        imageView.clipsToBounds = true

        return imageView
    }()

    private func configureHierarchy() {
        self.contentView.addSubview(albumImageView)
    }

    private func configureLayout() {
        albumImageView.snp.makeConstraints {
            let inset = 20
            $0.leading.trailing.centerY.equalToSuperview().inset(inset)
            $0.height.equalTo(albumImageView.snp.width)
        }
    }

    func layout() {
        configureHierarchy()
        configureLayout()
        self.layoutIfNeeded()
        albumImageView.layer.cornerRadius = albumImageView.frame.width * 0.2
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
