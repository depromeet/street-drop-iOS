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

    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground

        configureUI()
        bindViewModel()
        setupInitialOffset()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        profileImageView.makeCircleShape()
    }

    //MARK: - UI

    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        return button
    }()

    private lazy var locationImageView: UIImageView = {
        let image = UIImage(named: "locationBasic")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.font = .pretendard(size: 12, weight: 600)
        label.setLineHeight(lineHeight: 16)

        return label
    }()

    private lazy var locationTopView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        view.layer.cornerRadius = 15

        return view
    }()

    private lazy var topView: UIView = UIView()

    private lazy var albumCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .primaryBackground
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        collectionView.register(
            AlbumCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier
        )

        return collectionView
    }()

    // MusicInfo 요소
    private lazy var musicNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault // setLineHeight() 적용을위해 text 디폴트 값 필요
        label.textColor = .white
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 26.4)

        return label
    }()

    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center

        return stackView
    }()

    // comment 요소
    private lazy var genreLabels: [PaddingLabel] = []

    private lazy var genreLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5

        return stackView
    }()

    private lazy var voidView: UIView = UIView()

    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16.8)

        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5

        return stackView
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

        return stackView
    }()

    // listeningGuide 요소
    private lazy var youtubeMusicLogo: UIImageView = {
        let youtubeLogo = UIImage(named: "MusicLogo")
        let imageView = UIImageView(image: youtubeLogo)

        return imageView
    }()

    private lazy var listeningGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "바로 듣기"
        label.textColor = .white
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var listeningGuideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        return stackView
    }()

    // Like 요소
    private lazy var likeLogo: UIImageView = {
        let likeLogo = UIImage(named: "LikeLogo")
        let imageView = UIImageView(image: likeLogo)

        return imageView
    }()

    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "31.8K"
        label.textColor = .white
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        return stackView
    }()

    private lazy var listeningAndLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        return stackView
    }()
}

extension CommunityViewController {

    // MARK: - Data Binding

    private func bindViewModel() {
        viewModel.albumImages
            .bind(to: self.albumCollectionView.rx.items) { [weak self] collectionView, row, url in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlbumCollectionViewCell.identifier,
                    for: IndexPath(row: row, section: 0)) as? AlbumCollectionViewCell
                else {
                    return UICollectionViewCell()
                }

                cell.layout()

                self?.viewModel.fetchImage(url: url).observe(on: MainScheduler.instance)
                    .subscribe {
                        if let data = $0.element {
                            cell.setData(data)
                        }
                    }.disposed(by: self?.disposeBag ?? DisposeBag())

                return cell
            }.disposed(by: disposeBag)

        viewModel.addressTitle.subscribe{ [weak self] in
            self?.locationLabel.text = $0
        }.disposed(by: disposeBag)

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

    // MARK: - UI
    
    private func configureUI() {
        [locationImageView, locationLabel].forEach {
            locationTopView.addSubview($0)
        }

        [backButton, locationTopView].forEach {
            topView.addSubview($0)
        }

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

        [topView,
         albumCollectionView,
         musicInfoStackView,
         commentStackView,
         listeningAndLikeStackView
        ]
            .forEach {
                self.view.addSubview($0)
            }

        locationImageView.snp.makeConstraints {
            $0.width.height.equalTo(12.5)
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(11)
        }

        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationImageView.snp.trailing).offset(9)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        locationTopView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }

        backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        locationTopView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(topView)
        }

        albumCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(-self.view.frame.width/4)
            $0.height.equalTo(albumCollectionView.snp.width).multipliedBy(0.34)
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
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }

        listeningAndLikeStackView.snp.makeConstraints {
            $0.top.equalTo(commentStackView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
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

// MARK: - Private

private extension CommunityViewController {
    func generateGenreLabels(genres: [String]) -> [PaddingLabel] {
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

    // collectionView Layout
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let halfWidth = self.view.frame.width/2
        layout.itemSize = .init(width: halfWidth, height: halfWidth)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        return layout
    }
}

// MARK: - 무한스크롤
extension CommunityViewController: UICollectionViewDelegate {
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

        viewModel.changeCurrentMusic(to: index+1) //offset0일때, 0번 앨범이아니라 1번앨범내용이므로 index+1
    }

    // 4,5 + (1...5) + 1,2 로 들어오므로 1이 가운데에오도록 처음 offset지정
    private func setupInitialOffset() {
        guard let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }

        let cellWidth = layout.itemSize.width

        albumCollectionView.setContentOffset(
            CGPoint(x: cellWidth, y: .zero),
            animated: false
        )
    }
}

extension CommunityViewController {
    enum Constant {
        static let textDefault: String = " "
    }
}
