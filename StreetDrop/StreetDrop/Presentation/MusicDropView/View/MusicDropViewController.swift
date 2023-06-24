//
//  MusicDropViewController.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/18.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MusicDropViewController: UIViewController {

    enum Constant {
        static let textDefault = " "
        static let dropGuideTitle: String = "음악을 드랍할게요"
        static let commentPlaceHolder: String = "음악에 대해 하고싶은 말이 있나요?"
        static let dropButtonTitle: String = "드랍하기"
        static let communityButtonTitle: String = "커뮤니티 가이드"
        static let defaultCommentCount: String = "0/40"
    }

    private var viewModel: MusicDropViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewDidLoadEvent = PublishRelay<Void>()

    init(viewModel: MusicDropViewModel) {
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
        registerKeyboardNotification()
        viewDidLoadEvent.accept(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupPlaceHolder()
    }

    //MARK: - UI

    // 디자인 요소 (레이아웃 잡힌 후 그라데이션 layer 적용)
    private lazy var topGradientCircleView: UIView = UIView()
    private lazy var smallerCenterGradientCircleView: UIView = UIView()
    private lazy var largerCenterGradientCircleView: UIView = UIView()

    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.setTitle("음악검색", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .pretendard(size: 14, weight: 600)

        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("나가기", for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weight: 600)

        return button
    }()

    private lazy var topView: UIView = UIView()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag

        return scrollView
    }()

    private lazy var contentView: UIView = UIView()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 29.5)

        return label
    }()

    private lazy var dropGuideLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.dropGuideTitle
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 32)

        return label
    }()

    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray700
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var musicNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constant.textDefault
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: 700)
        label.setLineHeight(lineHeight: 24)

        return label
    }()

    private lazy var artistLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constant.textDefault
        label.numberOfLines = 1
        label.textColor = .gray300
        label.font = .pretendard(size: 12, weight: 500)
        label.setLineHeight(lineHeight: 18)

        return label
    }()

    private lazy var musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16

        return stackView
    }()

    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .pretendard(size: 14, weight: 500)
        textView.backgroundColor = .gray700
        textView.keyboardAppearance = .dark
        textView.showsVerticalScrollIndicator = false
        textView.sizeToFit()

        return textView
    }()

    private lazy var communityGuideButton: UIButton = {
        let icon = UIImage(named: "infoIcon")
        let button = UIButton(frame: .zero)
        button.setImage(icon, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
        button.setTitle(Constant.communityButtonTitle, for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .pretendard(size: 12, weightName: .semiBold)
        button.backgroundColor = .gray700
        button.layer.cornerRadius = 15
        button.clipsToBounds = false

        return button
    }()

    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.defaultCommentCount
        label.textColor = .gray300
        label.font = .pretendard(size: 14, weightName: .medium)
        label.isHidden = true

        return label
    }()

    private lazy var dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.dropButtonTitle, for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray300
        button.isEnabled = false

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

private extension MusicDropViewController {

    // MARK: - Action Binding

    func bindAction() {
        dropButton.rx.tap
            .bind {
                self.showDropAnimation()
            }.disposed(by: disposeBag)

        // 코멘트 플레이스홀더, 글자수라벨 설치, 줄 수 제한, 커멘트있을때만 드랍가능
        commentTextView.rx.didBeginEditing
            .subscribe { [weak self] element in
                self?.removePlaceHolder()
                self?.commentCountLabel.isHidden = false
            }.disposed(by: disposeBag)

        commentTextView.rx.didEndEditing
            .subscribe { [weak self] element in
                self?.setupPlaceHolder()
            }.disposed(by: disposeBag)

        commentTextView.rx.didChange
            .subscribe { [weak self] _ in
                self?.checkMaxCount(max: 40)
                self?.checkAvailableToDrop()
            }.disposed(by: disposeBag)

        commentTextView.rx.text.orEmpty
            .asObservable()
            .bind { [weak self] text in
                guard text != Constant.commentPlaceHolder else { return }
                self?.commentCountLabel.text = "\(text.count)/40"
            }.disposed(by: disposeBag)

        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind {
                self.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = MusicDropViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent.asObservable(),
            tapDropButton: self.dropButton.rx.tap.asObservable(),
            comment: self.commentTextView.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.convert(input: input, disposedBag: disposeBag)

        output.locationTitle
            .asDriver(onErrorJustReturn: (address: "", text: ""))
            .drive(onNext: { [weak self] locationTitle in
                self?.locationLabel.attributedText = locationTitle.text.changeColorPartially(
                    locationTitle.address,
                    to: .primary400
                )
            }).disposed(by: disposeBag)

        // musicTitle
        output.musicTitle
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] musicTitle in
                self?.musicNameLabel.text = musicTitle
            }).disposed(by: disposeBag)

        // artistTitle
        output.artistTitle
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] artistTitle in
                self?.artistLabel.text = artistTitle
            }).disposed(by: disposeBag)

        //albumImage
        output.albumImage
            .asDriver(onErrorJustReturn: Data())
            .drive(onNext: { [weak self] data in
                let albumImage = UIImage(data: data)
                self?.albumImageView.image = albumImage
                self?.albumImageView.layer.cornerRadius = 10
            }).disposed(by: disposeBag)

        // 👉 TODO: Error팝업띄우기
        output.errorDescription
            .asDriver()
            .drive(onNext: { errorDescription in
                // 팝업띄우기 로직
            }).disposed(by: disposeBag)
    }

    //MARK: - UI

    func configureUI() {
        self.view.clipsToBounds = true

        [backButton, cancelButton].forEach {
            topView.addSubview($0)
        }

        [locationLabel, dropGuideLabel, albumImageView, musicNameLabel, artistLabel]
            .forEach {
                musicInfoStackView.addArrangedSubview($0)
            }

        [commentTextView, commentCountLabel]
            .forEach {
                commentView.addSubview($0)
            }

        [musicInfoStackView, commentView, communityGuideButton, dropButton]
            .forEach {
                self.contentView.addSubview($0)
            }

        scrollView.addSubview(contentView)

        [topView, scrollView]
            .forEach {
                self.view.addSubview($0)
            }

        topView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }

        backButton.imageView?.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.leading.centerY.equalToSuperview()
            $0.trailing.equalTo(backButton.titleLabel!.snp.leading)
        }

        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.top.equalTo(topView.snp.bottom)
        }

        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView)
        }

        albumImageView.snp.makeConstraints {
            $0.width.equalTo(contentView).multipliedBy(0.30)
            $0.height.equalTo(albumImageView.snp.width)
        }

        musicInfoStackView.setCustomSpacing(0, after: locationLabel)
        musicInfoStackView.setCustomSpacing(0, after: musicNameLabel)

        musicInfoStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(contentView).inset(20)
            $0.centerX.equalTo(contentView)
        }

        commentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(112)
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(32)
        }

        commentTextView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16+40+10) // inset+countLabel+spacing
        }

        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(commentView.snp.trailing).inset(16)
            $0.bottom.equalTo(commentView.snp.bottom).inset(16)
        }

        communityGuideButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(commentView.snp.bottom).offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(32)
        }

        dropButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(contentView.snp.bottom).inset(30)
            $0.height.equalTo(54)
            $0.centerX.equalTo(contentView)
        }
    }
}

//MARK: - private
private extension MusicDropViewController {
    //MARK: - 코멘트 (placeHolder, 줄 수 제한, 빈값 확인,
    func setupPlaceHolder() {
        let placeHolder: String = Constant.commentPlaceHolder

        if(commentTextView.text == nil || commentTextView.text == "") {
            commentTextView.text = placeHolder
            commentTextView.textColor = .gray300
        }
    }

    func removePlaceHolder() {
        let placeHolder: String = Constant.commentPlaceHolder

        if(commentTextView.text == placeHolder) {
            commentTextView.text = nil
            commentTextView.textColor = .gray100
        }
    }

    func checkMaxCount(max: Int) {
        let count = commentTextView.text.count

        if count > max {
            commentTextView.text = String(commentTextView.text.dropLast())
        }
    }

    func checkAvailableToDrop() {
        let placeHolder: String = Constant.commentPlaceHolder

        if(commentTextView.text != nil
           && commentTextView.text != ""
           && commentTextView.text != placeHolder
        ) {
            dropButton.isEnabled = true
            dropButton.backgroundColor = .primary500
            dropButton.setTitleColor(.gray900, for: .normal)
        } else {
            dropButton.isEnabled = false
            dropButton.setTitleColor(
                .gray400,
                for: .normal
            )
            dropButton.backgroundColor = .gray300
        }
    }

    //MARK: - 드랍 액션
    func showDropAnimation() {
        let animationView = DropAnimationView()
        self.view.addSubview(animationView)

        animationView.snp.makeConstraints {
            $0.width.height.centerY.centerX.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }

    func removeViewItemComponents() {
        topView.removeFromSuperview()
        scrollView.removeFromSuperview()
    }

    //MARK: - 키보드

    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        scrollView.contentInset.bottom = keyboardFrame.size.height

        let activeRect = commentTextView.convert(commentTextView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }

    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(.zero, animated: true)
    }
}
