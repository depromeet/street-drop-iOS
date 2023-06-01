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

    //MARK: - 디자인 요소 (레이아웃 잡힌 후 그라데이션 layer 적용)
    private var topGradientCircleView: UIView = UIView()
    private var smallerCenterGradientCircleView: UIView = UIView()
    private var LargerCenterGradientCircleView: UIView = UIView()

    //MARK: - 뷰 아이템 요소
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 29.5)

        return label
    }()

    private let dropGuideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 32)

        return label
    }()

    private let albumImageView: UIImageView = {
        let loadingImage = UIImage(systemName: "slowmo")
        let imageView = UIImageView(image: loadingImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        return imageView
    }()

    private let musicNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: 700)
        label.setLineHeight(lineHeight: 24)

        return label
    }()

    private let artistLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .pretendard(size: 12, weight: 500)
        label.setLineHeight(lineHeight: 18)

        return label
    }()

    private let musicInfoStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 5
    )

    private let commentTextView: UITextView = UITextView(
        backgroundColor: .darkGray,
        cornerRadius: 10,
        inset: 10
    )

    private let CommentGuidanceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .pretendard(size: 11, weight: 400)
        label.setLineHeight(lineHeight: 17)
        
        return label
    }()

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
                self?.locationLabel.text = element.text
                self?.locationLabel.attributedText = element.text.changeColorPartially(
                    element.adress,
                    to: .blue
                )
            }
        }.disposed(by: disposeBag)

        viewModel.dropGuideTitle.subscribe { [weak self] in
            self?.dropGuideLabel.text = $0
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
        [locationLabel, dropGuideLabel, albumImageView, musicNameLabel, artistLabel]
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

        musicInfoStackView.setCustomSpacing(3, after: locationLabel)
        musicInfoStackView.setCustomSpacing(32, after: dropGuideLabel)
        musicInfoStackView.setCustomSpacing(16, after: albumImageView)

        musicInfoStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }

        commentStackView.snp.makeConstraints {
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.greaterThanOrEqualToSuperview().multipliedBy(0.1)
            $0.centerX.equalToSuperview()
        }

        dropButton.snp.makeConstraints {
            $0.width.equalTo(commentTextView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
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
}
