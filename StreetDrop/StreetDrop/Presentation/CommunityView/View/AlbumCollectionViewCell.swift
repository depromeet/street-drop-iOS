//
//  AlbumImageCollectionViewCell.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/24.
//

import UIKit

import SnapKit

final class AlbumCollectionViewCell: UICollectionViewCell {

    static let identifier: String = "AlbumCollectionViewCell"

    private let albumImageView: UIImageView = {
        let loadingImage = UIImage(systemName: "slowmo")
        let imageView = UIImageView(image: loadingImage) // 디폴트이미지
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white

        return imageView
    }()

    private func configureHierarchy() {
        self.contentView.addSubview(albumImageView)
    }

    private func configureLayout() {
        albumImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }

    func layout() {
        configureHierarchy()
        configureLayout()
    }

    func setupImage(image: Data) {
        let image = UIImage(data: image)
        self.albumImageView.image = image
    }
}
