//
//  CommunityViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/24.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

final class CommunityViewController: UIViewController {
    private let viewModel: CommunityViewModel
    private let disposeBag = DisposeBag()

    private lazy var albumCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            AlbumCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier
        )

        return collectionView
    }()

    // MusicInfo 요소
    private let musicNameLabel: UILabel = UILabel(
        font: .title2
    )

    private let artistLabel: UILabel = UILabel(
        font: .body
    )

    private let musicInfoStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 5
    )

    // comment 요소
    private var genreLabels: [PaddingLabel] = []

    private let genreLabelStackView: UIStackView = UIStackView(
        axis: .horizontal,
        spacing: 5
    )

    private let voidView: UIView = UIView()

    private let commentLabel: UILabel = UILabel(
        font: .caption1,
        numberOfLines: 0
    )

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)

        return imageView
    }()

    private let nicknameLabel: UILabel = UILabel(
        font: .caption1
    )

    private let dateLabel: UILabel = UILabel(
        font: .caption2
    )

    private let userInfoStackView: UIStackView = UIStackView(
        axis: .horizontal,
        spacing: 5
    )

    private let commentStackView: UIStackView = UIStackView(
        spacing: 5,
        backgroundColor: .darkGray,
        cornerRadius: 10,
        inset: 20
    )

    // listeningGuide 요소
    private let youtubeMusicLogo: UIImageView = {
        let youtubeLogo = UIImage(named: "MusicLogo")
        let imageView = UIImageView(image: youtubeLogo)

        return imageView
    }()

    private let listeningGuideLabel: UILabel = UILabel(
        text: "음악듣기",
        font: .body
    )

    private let listeningGuideStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 10,
        backgroundColor: .darkGray,
        cornerRadius: 10,
        inset: 10
    )

    // Like 요소
    private let likeLogo: UIImageView = {
        let likeLogo = UIImage(named: "LikeLogo")
        let imageView = UIImageView(image: likeLogo)

        return imageView
    }()

    private let likeCountLabel: UILabel = UILabel(
        text: "31.8K",
        font: .body
    )

    private let likeStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 10,
        backgroundColor: .darkGray,
        cornerRadius: 10,
        inset: 10
    )

    private let listeningAndLikeStackView: UIStackView = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 10
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        configureHierarchy()
        configureLayout()
        bindViewModel()
    }

    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func generateGenreLabels(genres: [String]) -> [PaddingLabel] {
        var labels: [PaddingLabel] = []
        genres.forEach { genreTitle in
            let label = PaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            label.text = genreTitle
            label.textAlignment = .center
            label.font = .preferredFont(forTextStyle: .caption1)
            label.numberOfLines = 1
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
            label.backgroundColor = .systemGray
            labels.append(label)
        }

        return labels
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let halfWidth = self.view.frame.width/2
        layout.itemSize = .init(width: halfWidth, height: halfWidth)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        return layout
    }
}

//MARK: - 뷰모델 바인딩
extension CommunityViewController {
    private func bindViewModel() {
        viewModel.MusicTitle.subscribe { [weak self] in
            self?.musicNameLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.artistTitle.subscribe { [weak self] in
            self?.artistLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.genresText.subscribe { [weak self] in
            if let self = self {
                self.genreLabels.forEach { view in
                    (view as UIView).removeFromSuperview()
                }
                self.genreLabels = self.generateGenreLabels(genres: $0)
                self.updateGenreLabelStackView()
            }
        }.disposed(by: disposeBag)

        viewModel.commentText.subscribe { [weak self] in
            self?.commentLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.profileImage.subscribe { [weak self] urlString in
            guard let self = self else { return }
            self.viewModel.fetchImage(url: urlString)
                .observe(on: MainScheduler.instance)
                .subscribe {
                    if let data = $0.element {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)

        viewModel.nicknameText.subscribe { [weak self] in
            self?.nicknameLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.dateText.subscribe { [weak self] in
            self?.dateLabel.text = $0
        }.disposed(by: disposeBag)
    }
}

//MARK: - 계층, 레이아웃
extension CommunityViewController {
    private func configureHierarchy() {
        [musicNameLabel, artistLabel].forEach {
            musicInfoStackView.addArrangedSubview($0)
        }

        genreLabels.forEach {
            genreLabelStackView.addArrangedSubview($0)
        }

        genreLabelStackView.addArrangedSubview(voidView)

        [profileImageView, nicknameLabel, dateLabel].forEach {
            userInfoStackView.addArrangedSubview($0)
        }

        [genreLabelStackView, commentLabel, userInfoStackView].forEach {
            commentStackView.addArrangedSubview($0)
        }

        [youtubeMusicLogo, listeningGuideLabel].forEach {
            listeningGuideStackView.addArrangedSubview($0)
        }

        [likeLogo, likeCountLabel].forEach {
            likeStackView.addArrangedSubview($0)
        }

        [listeningGuideStackView, likeStackView].forEach {
            listeningAndLikeStackView.addArrangedSubview($0)
        }

        [albumCollectionView, musicInfoStackView, commentStackView, listeningAndLikeStackView]
            .forEach {
                self.view.addSubview($0)
            }
    }

    private func configureLayout() {
        let viewWidth = self.view.frame.width

        albumCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(-viewWidth/4)
            $0.height.equalTo(albumCollectionView.snp.width).multipliedBy(0.4)
        }

        musicInfoStackView.snp.makeConstraints {
            $0.top.equalTo(albumCollectionView.snp.bottom)
            $0.height.greaterThanOrEqualToSuperview().multipliedBy(0.1)
            $0.centerX.equalToSuperview()
        }

        commentLabel.setContentHuggingPriority(.init(1), for: .vertical)
        nicknameLabel.setContentHuggingPriority(.init(1), for: .horizontal)
        voidView.setContentHuggingPriority(.init(1), for: .horizontal)

        profileImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(profileImageView.snp.width)
        }

        commentStackView.snp.makeConstraints {
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }

        listeningAndLikeStackView.snp.makeConstraints {
            $0.top.equalTo(commentStackView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        youtubeMusicLogo.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalTo(youtubeMusicLogo.snp.height)
        }

        likeLogo.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(likeLogo.snp.height)
        }

        listeningGuideStackView.snp.makeConstraints {
            $0.width.equalTo(likeStackView.snp.width)
        }
    }

    private func updateGenreLabelStackView() {
        genreLabels.forEach {
            genreLabelStackView.addArrangedSubview($0)
        }

        genreLabelStackView.addArrangedSubview(voidView)
    }
}

//MARK: - 컬렉션뷰 데이터소스, 컬렉션뷰 델리게이트
extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.communityInfoCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let albumImageURL = viewModel.albumImages[indexPath.item]
        viewModel.fetchImage(url: albumImageURL)
            .observe(on: MainScheduler.instance)
            .subscribe {
                if let data = $0.element {
                    cell.prepare(image: data)
                }
            }.disposed(by: disposeBag)

        return cell
    }

    // 무한스크롤 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }

        let count = viewModel.communityInfoCount
        let cellWidth = layout.itemSize.width

        if scrollView.contentOffset.x < cellWidth {
            scrollView.setContentOffset(
                .init(x: scrollView.contentSize.width-(cellWidth*3), y: 0),
                animated: false
            )
        }

        if scrollView.contentOffset.x > cellWidth * Double(count-3) {
            scrollView.setContentOffset(
                .init(x: cellWidth, y: 0),
                animated: false
            )
        }
    }

    // 스크롤시 한 Cell씩 가운데 오도록 설정
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }

        let cellWidth = layout.itemSize.width
        let estimatedIndex = scrollView.contentOffset.x / cellWidth
        let index: Int

        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }

        targetContentOffset.pointee = CGPoint(
            x: (CGFloat(index) * cellWidth),
            y: 0
        )

        viewModel.changeCurrentMusic(to: index)
    }
}
