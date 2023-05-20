//
//  MusicDropViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/18.
//

import UIKit


final class MusicDropViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        configureHierarchy()
        configureLayout()
    }

    //MARK: - 뷰 아이템 요소
    private let locationLabel: UILabel = UILabel(
        text: "'성동구 성수1가 1동' 위치에 \n 음악을 드랍할게요",
        textAlignment: .center,
        font: .title2,
        numberOfLines: 2
        // 👉 남은이슈: 주소만 글씨색 다르게하기
    )

    private let albumImageView: UIImageView = UIImageView(
        cornerRadius: 10
    )

    private let albumNameLabel: UILabel = UILabel(
        text: "Can't Control Myself",
        font: .body
    )

    private let singerNameLabel: UILabel = UILabel(
        text: "태연",
        font: .caption1
    )

    private let musicInfoStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 5
    )

    private let commentTextView: UITextView = UITextView(
        text: "음악에 대해 하고싶은 말이 있나요?",
        backgroundColor: .darkGray,
        cornerRadius: 10,
        inset: 10
    )

    private let CommentGuidanceLabel: UILabel = UILabel(
        text: "• 텍스트는 생략이 가능하며 욕설, 성희롱, 비방과 같은 내용은 삭제합니다",
        font: .caption2
    )

    private let commentStackView: UIStackView = UIStackView(
        spacing: 5
    )

    private let dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("드랍하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .darkGray

        return button
    }()
}

//MARK: - 계층, 레이아웃
extension MusicDropViewController {
    private func configureHierarchy() {
        [locationLabel, albumImageView, albumNameLabel, singerNameLabel]
            .forEach {
                musicInfoStackView.addArrangedSubview($0)
            }

        [commentTextView, CommentGuidanceLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }


        [musicInfoStackView, commentStackView, dropButton]
            .forEach {
                self.view.addSubview($0)
            }
    }

    private func configureLayout() {
        albumImageView.snp.makeConstraints {
            $0.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.30)
            $0.height.equalTo(albumImageView.snp.width)
        }

        musicInfoStackView.snp.makeConstraints {
            $0.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.8)
            $0.height.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide).multipliedBy(0.4)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }

        musicInfoStackView.setCustomSpacing(30, after: locationLabel)

        commentStackView.snp.makeConstraints {
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.greaterThanOrEqualToSuperview().multipliedBy(0.1)
            $0.centerX.equalToSuperview()
        }

        dropButton.snp.makeConstraints {
            $0.width.equalTo(commentTextView)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.07)
            $0.centerX.equalToSuperview()
        }
    }
}
