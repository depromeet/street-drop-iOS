//
//  CommunityViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/24.
//

import UIKit

import SnapKit

final class CommunityViewController: UIViewController {
    private var musicList: [String]
    private var currentIndex: Int = .zero

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
        text: "Can't Control myself",
        font: .title2
    )

    private let artistLabel: UILabel = UILabel(
        text: "태연",
        font: .body
    )

    private let musicInfoStackView: UIStackView = UIStackView(
        alignment: .center,
        spacing: 5
    )

    // comment 요소
    private lazy var genreLabels: [PaddingLabel] = {
        return generateGenreLabels(genres: ["신남쓰", "장르다"])
    }()

    private let genreLabelStackView: UIStackView = UIStackView(
        axis: .horizontal,
        spacing: 5
    )

    private let voidView: UIView = UIView()

    private let commentLabel: UILabel = UILabel(
        text: "삶은 너무 짧습니다...\n후회하지 말고 잘 사시길 바랍니다",
        font: .caption1,
        numberOfLines: 0
    )

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "car")

        return imageView
    }()

    private let nicknameLabel: UILabel = UILabel(
        text: "일이삼사오육칠팔구십일이",
        font: .caption1
    )

    private let dateLabel: UILabel = UILabel(
        text: "2023.04.01",
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

        prepareInfiniteCarousel()
        configureHierarchy()
        configureLayout()
    }

    init(musicList: [String], currentIndex: Int) {
        self.musicList = musicList
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareInfiniteCarousel() {
        // originData: "1,2,3" -> 앞뒤2개씩 추가 to be: "2,3,1,2,3,1,2"
        var newMusicList: [String] = []
        newMusicList += musicList[musicList.count-2...musicList.count - 1]
        newMusicList += musicList
        newMusicList += musicList[0...1]

        musicList = newMusicList
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
}

extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return musicList.count
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

        cell.prepare(number: musicList[indexPath.item])

        return cell
    }

    // 무한스크롤 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }

        let count = musicList.count
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
}

extension CommunityViewController: UIScrollViewDelegate {
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
    }
}
