//
//  MusicDropViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/18.
//

import UIKit

import SnapKit
import RxSwift

final class MusicDropViewController: UIViewController {
    private var viewModel: MusicDropViewModel
    private let disposeBag: DisposeBag = DisposeBag()

    init(viewModel: MusicDropViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

final class MusicDropViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground

        configureHierarchy()
        configureLayout()
        viewModel.fetchAlbumImage()
        viewModel.fetchAdress()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        makeViewIntoGradientCircle()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.commentTextView.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        makeViewIntoGradientCircle()
    }

    //MARK: - 디자인 요소 (레이아웃 잡힌 후 그라데이션 layer 적용)
    private var topGradientCircleView: UIView = UIView()
    private var smallerCenterGradientCircleView: UIView = UIView()
    private var LargerCenterGradientCircleView: UIView = UIView()

    //MARK: - 뷰 아이템 요소
    private let locationLabel: UILabel = UILabel(
        
    }

    //MARK: - 뷰 아이템 요소
    private let locationLabel: UILabel = UILabel(
        text: "'성동구 성수1가 1동' 위치에 \n 음악을 드랍할게요",
        textAlignment: .center,
        font: .title2,
        numberOfLines: 2
    )

    private let albumImageView: UIImageView = UIImageView(
        cornerRadius: 10
    )

    private let musicNameLabel: UILabel = UILabel(
        font: .body
    )

    private let artistLabel: UILabel = UILabel(
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

    private lazy var dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .darkGray
        button.addAction(touchedUpDropButton(), for: .touchUpInside)

        return button
    }()

    private lazy var dropAnimationImageView: UIImageView = {
        let dropAnimationImage: UIImage = UIImage(named: "DropAnimationImage") ?? UIImage()
        let imageView = UIImageView(image: dropAnimationImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
}

//MARK: - 뷰모델 바인딩
extension MusicDropViewController {
    private func bindViewModel() {
        viewModel.locationTitle.subscribe { [weak self] in
            if let element: (adress: String, text: String) = $0.element {
                self?.locationLabel.attributedText = element.text.changeColorPartially(
                    element.adress,
                    to: .blue
                )
            }
        }.disposed(by: disposeBag)

        viewModel.albumImage.subscribe { [weak self] data in
            if let data = data {
                DispatchQueue.main.async {
                    self?.albumImageView.image = UIImage(data: data)
                }
            }
        }.disposed(by: disposeBag)

        viewModel.MusicTitle.subscribe { [weak self] in
            self?.musicNameLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.artistTitle.subscribe { [weak self] in
            self?.artistLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.commentPalceHolder.subscribe { [weak self] in
            self?.commentTextView.text = $0
        }.disposed(by: disposeBag)

        viewModel.commentGuidanceText.subscribe { [weak self] in
            self?.CommentGuidanceLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.dropButtonTitle.subscribe { [weak self] in
            self?.dropButton.setTitle($0, for: .normal)
        }.disposed(by: disposeBag)

        viewModel.errorDescription.subscribe { _ in
            // 👉 TODO: Error팝업띄우기
        }.disposed(by: disposeBag)
    }
}

//MARK: - 드랍 액션
extension MusicDropViewController {
    private func touchedUpDropButton() -> UIAction {
        return UIAction { [weak self] _ in
            self?.viewModel.drop(content: self?.commentTextView.text ?? "")
            // 👉TODO - 애니메이션 추갸하기, 1초정도 보여준 후 VC 네비게이션바에서 pop하기
            self?.showDropAnimation()
        }
    }

    private func showDropAnimation() {
        removeViewItemComponents()

        self.view.addSubview(dropAnimationImageView)
        dropAnimationImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
    }

    private func removeViewItemComponents() {
        [musicInfoStackView, commentStackView, dropButton]
            .forEach {
                $0.removeFromSuperview()
            }
    }
}

//MARK: - 계층, 레이아웃
extension MusicDropViewController {
    private func configureHierarchy() {
        [locationLabel, albumImageView, musicNameLabel, artistLabel]
            .forEach {
                musicInfoStackView.addArrangedSubview($0)
            }

        [commentTextView, CommentGuidanceLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }

        // 디자인요소인 GradientCircleView들 먼저 add합니다. 순서 변경 불가능합니다.
        [LargerCenterGradientCircleView, smallerCenterGradientCircleView, topGradientCircleView]
            .forEach {
                self.view.addSubview($0)
            }

        [musicInfoStackView, commentStackView, dropButton]
            .forEach {
                self.view.addSubview($0)
            }
    }

    private func configureLayout() {
        topGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.1)
            $0.height.equalTo(topGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.1)
        }

        smallerCenterGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.1)
            $0.height.equalTo(smallerCenterGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
        }

        LargerCenterGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.4)
            $0.height.equalTo(LargerCenterGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
        }

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

    private func makeViewIntoGradientCircle() {
        topGradientCircleView.makeGradientCircleView(
            colors: [
                UIColor.darkGray.cgColor,
                UIColor.primaryBackground.cgColor,
                UIColor.darkGray.cgColor
            ],
            gradientLocations: [0, 0.5, 1],
            viewBackgroundColor: .primaryBackground
        )

        [smallerCenterGradientCircleView, LargerCenterGradientCircleView].forEach {
            $0.makeGradientCircleView(
                colors: [
                    UIColor.primaryBackground.cgColor,
                    UIColor.primaryBackground.cgColor,
                    UIColor.blue.cgColor
                ],
                gradientLocations: [0, 0.8, 1],
                viewBackgroundColor: .primaryBackground
            )
        }
    }
    
    private let dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("드랍하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .darkGray

        return button
    }()
}
