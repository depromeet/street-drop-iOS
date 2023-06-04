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
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0.5

        return imageView
    }()

    private let gradationView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(red: 0.399, green: 0.375, blue: 0.833, alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false

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
