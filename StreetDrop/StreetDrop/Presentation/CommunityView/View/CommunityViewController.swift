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
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let changedAlbumCollectionViewIndexEvent = PublishRelay<Int>()
    private let deleteEvent = PublishRelay<Int>()
    private let editEvent = PublishRelay<(editedComment: String, index: Int)>()

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
        bindAction()
        bindViewModel()
        viewDidLoadEvent.accept(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        profileImageView.makeCircleShape()
        makeCommentViewToGradientView()
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
        label.textColor = .gray100
        label.font = .pretendard(size: 12, weight: 600)
        label.setLineHeight(lineHeight: 16)

        return label
    }()

    private lazy var locationTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
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
        label.textColor = .gray200
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
        stackView.spacing = 8

        return stackView
    }()

    private lazy var voidView: UIView = UIView()

    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = Constant.textDefault
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false

        return textView
    }()

    private lazy var optionButton: UIButton = {
        let icon = UIImage(named: "optionIcon")
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.backgroundColor = .clear

        return button
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .gray100
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 19.6)

        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .gray300
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16.8)

        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8

        return stackView
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = UIColor(red: 0.089, green: 0.099, blue: 0.12, alpha: 1)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.masksToBounds = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

        return stackView
    }()

    // listeningGuide 요소
    private lazy var listenButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("바로 듣기", for: .normal)
        button.setTitleColor(.primary500, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: 700)

        return button
    }()

    private lazy var listeningGuideView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .gray800
        view.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        return view
    }()

    // Like 요소
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let likeLogo = UIImage(named: "likeFill")
        button.setImage(likeLogo, for: .normal)

        return button
    }()

    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "31.8K"
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: 500)
        label.setLineHeight(lineHeight: 21)

        return label
    }()

    private lazy var likeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .gray800
        view.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        return view
    }()
}

private extension CommunityViewController {
    // MARK: - Action Binding

    func bindAction() {
        backButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        listenButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                let musicName = self.musicNameLabel.text ?? ""
                let artistName = self.artistLabel.text ?? ""
                
                // urlScheme을 통해 유튜브뮤직  앱으로 이동
                let youtubeMusicAppURLString = "youtubemusic://search?q=\(musicName)-\(artistName)"
                if let encodedYoutubeMusicAppURLString = youtubeMusicAppURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedYoutubeMusicAppURL = URL(string: encodedYoutubeMusicAppURLString),
                   UIApplication.shared.canOpenURL(encodedYoutubeMusicAppURL) {
                    UIApplication.shared.open(encodedYoutubeMusicAppURL)
                    return
                }
                
                // urlScheme을 통해 유튜브뮤직 앱으로 이동 실패 시, 유튜브뮤직 웹사이트 url으로 이동
                let youtubeMusicWebURLString = "https://music.youtube.com/search?q=\(musicName)-\(artistName)"
                if let encodedYoutubeMusicWebURLString = youtubeMusicWebURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedYoutubeMusicWebURL = URL(string: encodedYoutubeMusicWebURLString),
                   UIApplication.shared.canOpenURL(encodedYoutubeMusicWebURL) {
                    UIApplication.shared.open(encodedYoutubeMusicWebURL)
                    return
                }
            }
            .disposed(by: disposeBag)

        optionButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let optionModalViewModel = OptionModalViewModel(
                    itemId: self.viewModel.communityInfos[self.viewModel.currentIndex].id,
                    musicIndex: self.viewModel.currentIndex
                )
                optionModalViewModel.delegate = self

                let modalView = OptionModalViewController(viewModel: optionModalViewModel)
                modalView.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(modalView, animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = CommunityViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent.asObservable(),
            changedIndex: self.changedAlbumCollectionViewIndexEvent.asObservable(),
            tapLikeButtonEvent: self.likeButton.rx.tap.asObservable(),
            deleteEvent: self.deleteEvent.asObservable(),
            editEvent: self.editEvent.asObservable()
        )

        let output = viewModel.convert(input: input, disposedBag: disposeBag)

        output.albumImages
            .bind(to: self.albumCollectionView.rx.items) { collectionView, row, url in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlbumCollectionViewCell.identifier,
                    for: IndexPath(row: row, section: 0)) as? AlbumCollectionViewCell
                else {
                    return UICollectionViewCell()
                }

                cell.layout()
                cell.setData(url)

                return cell

            }.disposed(by: disposeBag)

        output.addressTitle
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.locationLabel.text = $0
            }.disposed(by: disposeBag)

        output.currentIndex
            .asDriver(onErrorJustReturn: 0)
            .drive {  [weak self] in
                self?.setupInitialOffset(index: $0)
            }.disposed(by: disposeBag)

        output.musicTitle
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.musicNameLabel.text = $0
            }.disposed(by: disposeBag)

        output.artistTitle
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.artistLabel.text = $0
            }.disposed(by: disposeBag)

        output.genresText
            .asDriver(onErrorJustReturn: [""])
            .drive { [weak self] in
                guard let self = self else { return }
                self.genreLabels.forEach { view in
                    (view as UIView).removeFromSuperview()
                }
                self.genreLabels = self.generateGenreLabels(genres: $0)
                self.updateGenreLabelStackView()
            }.disposed(by: disposeBag)

        output.commentText
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.commentTextView.text = $0
                self?.commentTextView.setAttributedString(
                    font: .pretendard(size: 14, weightName: .medium),
                    lineSpacing: 4,
                    color: .gray50
                )
            }.disposed(by: disposeBag)

        output.profileImageURL
            .asDriver(onErrorJustReturn: String())
            .drive { [weak self] url in
                guard let self = self else { return }
                // 프로필 이미지 URL 생기면 맨 아랫 줄로 바꾸기. 1차 배포는 애플 이미지 사용
                let image = UIImage(systemName: url)?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)

                self.profileImageView.image = image

                //self.profileImageView.setImage(with: url, disposeBag: self.disposeBag)
            }.disposed(by: disposeBag)

        output.nicknameText
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.nicknameLabel.text = $0
            }.disposed(by: disposeBag)

        output.dateText
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                self?.dateLabel.text = $0
            }.disposed(by: disposeBag)

        output.isLiked
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isLiked in
                let likeFillImage = UIImage(named: "likeFill")
                let likeEmptyImage = UIImage(named: "likeEmpty")

                self?.likeButton.setImage(isLiked ? likeFillImage : likeEmptyImage, for: .normal)
            }.disposed(by: disposeBag)

        output.likeCount
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] likeCount in
                self?.likeCountLabel.text = likeCount
            }.disposed(by: disposeBag)

        output.infoIsEmpty
            .asDriver(onErrorJustReturn: ())
            .drive (onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)

        // 👉 TODO: Error팝업띄우기
        output.errorDescription
            .asDriver()
            .drive(onNext: { errorDescription in
                // 팝업띄우기 로직
            }).disposed(by: disposeBag)
    }

    // MARK: - UI
    
    func configureUI() {
        self.view.clipsToBounds = true
        
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

        [genreLabelStackView, commentTextView, userInfoStackView].forEach {
            commentStackView.addArrangedSubview($0)
        }

        commentStackView.addSubview(optionButton)

        [listenButton].forEach {
            listeningGuideView.addSubview($0)
        }

        [likeButton, likeCountLabel].forEach {
            likeView.addSubview($0)
        }

        [topView,
         albumCollectionView,
         musicInfoStackView,
         commentStackView,
         listeningGuideView,
         likeView
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
            $0.top.equalTo(topView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(-self.view.frame.width/4)
            $0.height.equalTo(albumCollectionView.snp.width).multipliedBy(0.34)
        }

        musicInfoStackView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(albumCollectionView.snp.bottom).offset(8)
            $0.height.equalTo(51)
            $0.centerX.equalToSuperview()
        }

        commentTextView.setContentHuggingPriority(.init(1), for: .vertical)
        nicknameLabel.setContentHuggingPriority(.init(1), for: .horizontal)
        voidView.setContentHuggingPriority(.init(1), for: .horizontal)

        optionButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(24)
        }

        profileImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(profileImageView.snp.width)
        }

        commentStackView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(musicInfoStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().multipliedBy(0.33)
        }

        listenButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        listeningGuideView.snp.makeConstraints {
            $0.top.equalTo(commentStackView.snp.bottom).offset(16)
            $0.height.equalTo(56)
            $0.leading.equalTo(commentStackView)
            $0.trailing.equalTo(commentStackView.snp.trailing).multipliedBy(0.66)
        }

        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerX.equalToSuperview().multipliedBy(0.8)
            make.centerY.equalToSuperview()
        }

        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
        }

        likeView.snp.makeConstraints {
            $0.leading.equalTo(listeningGuideView.snp.trailing).offset(8)
            $0.trailing.equalTo(commentStackView)
            $0.top.height.equalTo(listeningGuideView)
        }
    }

    func updateGenreLabelStackView() {
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
            let label = PaddingLabel(padding: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
            label.text = genreTitle
            label.textColor = .gray800
            label.textAlignment = .center
            label.font = .pretendard(size: 12, weight: 600)
            label.numberOfLines = 1
            label.layer.cornerRadius = 12
            label.clipsToBounds = true
            label.backgroundColor = .pointGradation_1
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

    func makeCommentViewToGradientView() {
        commentStackView.makeGradientView(
            colors: [
                UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.1).cgColor,
                UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.05).cgColor,
                UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0).cgColor
              ],
            gradientLocations: [0, 0.29, 1],
            viewBackgroundColor: .gray800,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 0.75)
        )
    }
}

// MARK: - 무한스크롤
extension CommunityViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 실제 데이터가 4개이상일 때만 무한스크롤(2,3개 일때는 X)
        // 2,3개일 때 앞뒤로 빈데이터를 넣어줬기 때문에 맨 앞이 빈데이터가 아닌지 확인
        guard let firstInfo = viewModel.communityInfos.first,
              !firstInfo.albumImageURL.isEmpty,
              let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }

        let count = viewModel.communityInfos.count
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

        // 스크롤뷰 offset 0일때, 0번 앨범이아니라 1번 앨범이 가운데이므로 기본으로 index+1 과 씽크를 맞춰야 함
        changedAlbumCollectionViewIndexEvent.accept(index+1)
    }

    private func setupInitialOffset(index: Int) {
        guard let layout = self.albumCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else { return }
        albumCollectionView.layoutIfNeeded()

        let cellWidth = layout.itemSize.width
        albumCollectionView.setContentOffset(
            CGPoint(x: (cellWidth * CGFloat(index - 1)), y: .zero),
            animated: false
        )
    }
}

extension CommunityViewController: OptionModalViewModelDelegate {
    func editComment(musicIndex: Int) {
        let editInfo = self.viewModel.communityInfos[musicIndex].convertToEditInfo()
        let editViewModel = EditViewModel(editInfo: editInfo, musicIndex: musicIndex)
        editViewModel.delegate = self
        let editViewController = EditViewController(viewModel: editViewModel)

        self.navigationController?.present(editViewController, animated: true)
    }

    func deleteMusic(_ isSuccess: Bool, toastTitle: String, musicIndex: Int) {
        guard isSuccess else {
            //TODO: - 토스트띄워주기 (toastTitle)
            return
        }

        self.albumCollectionView.performBatchUpdates { [weak self] in
            self?.deleteEvent.accept(musicIndex)
        }
    }
}

extension CommunityViewController: EditViewModelDelegate {
    func editComment(editedComment: String, musicIndex: Int) {
        self.commentTextView.text = editedComment
        self.editEvent.accept((editedComment: editedComment, index: musicIndex))
    }
}
