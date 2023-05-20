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
