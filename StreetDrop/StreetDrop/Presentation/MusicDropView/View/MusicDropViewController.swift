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

class MusicDropViewController: UIViewController, Toastable, Alertable {

    enum Constant {
        static let textDefault = " "
        static let commentPlaceHolder: String = "노래, 현재 감정, 상황, 관련 에피소드, 거리, 가수 등 떠오르는 말을 적어보세요."
        static let dropButtonTitle: String = "드랍하기"
        static let communityButtonTitle: String = "커뮤니티 가이드"
        static let defaultCommentCount: String = "0/40"
    }

    private var viewModel: MusicDropViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let keyboardShowEvent = PublishRelay<Void>()
    private let keyboardHideEvent = PublishRelay<Void>()
    private lazy var animationView = DropAnimationView()

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

    lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.setTitle("음악 검색", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .pretendard(size: 14, weight: 600)

        return button
    }()

    lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("나가기", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weight: 600)

        return button
    }()

    lazy var topView: UIView = UIView()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        // 여백 터치시 키보드 내려가게 하기위해 TapGestureRecognizer추가 (추가하지 않으면 짧은 터치 제스처가 스크롤하는 제스처로 인정됌)
        let singleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(endEditing)
        )
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)

        return scrollView
    }()

    lazy var contentView: UIView = UIView()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.textDefault
        label.textColor = .white
        label.numberOfLines = 2
        label.font = .pretendard(size: 20, weight: 700)

        return label
    }()

    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray700
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
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
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center

        return label
    }()

    private lazy var artistLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constant.textDefault
        label.numberOfLines = 1
        label.textColor = .gray300
        label.font = .pretendard(size: 12, weight: 500)
        label.setLineHeight(lineHeight: 16)

        return label
    }()

    lazy var musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16

        return stackView
    }()

    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray700.cgColor
        view.clipsToBounds = true
        return view
    }()

    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .pretendard(size: 14, weight: 500)
        textView.backgroundColor = .gray700
        textView.keyboardAppearance = .dark
        textView.keyboardDismissMode = .interactive
        textView.showsVerticalScrollIndicator = false
        textView.returnKeyType = .done
        textView.delegate = self

        return textView
    }()

    private lazy var communityGuideButton: UIButton = {
        let icon = UIImage(named: "infoIcon")
        let button = UIButton(frame: .zero)
        button.setImage(icon, for: .normal)
        button.setTitle(Constant.communityButtonTitle, for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .pretendard(size: 12, weightName: .semiBold)
        button.backgroundColor = .gray700
        button.layer.cornerRadius = 15
        button.clipsToBounds = false

        return button
    }()

    private lazy var communityGuideDetailView: UIView = CommunityGuideDetailView()

    private lazy var commentClearButton: UIButton = {
        let icon = UIImage(named: "cancleButton")
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.isHidden = true
        button.isEnabled = false

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

    lazy var dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.dropButtonTitle, for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .bold)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray300
        button.isEnabled = false

        return button
    }()
}

private extension MusicDropViewController {

    // MARK: - Action Binding

    func bindAction() {
        dropButton.rx.tap
            .bind { [weak self] in
                guard self?.viewModel.state == .drop else { return }
                self?.showDropAnimation()
            }.disposed(by: disposeBag)

        // 코멘트 플레이스홀더, 글자수라벨 설치, 줄 수 제한, 커멘트있을때만 드랍가능
        commentTextView.rx.didBeginEditing
            .subscribe { [weak self] element in
                self?.removePlaceHolder()
                self?.commentCountLabel.isHidden = false
                self?.commentClearButton.isHidden = false
                self?.commentClearButton.isEnabled = true
                self?.commentView.layer.borderColor = UIColor.darkPrimary_25.cgColor
            }.disposed(by: disposeBag)

        commentTextView.rx.didEndEditing
            .subscribe { [weak self] element in
                self?.setupPlaceHolder()
                self?.commentClearButton.isHidden = true
                self?.commentClearButton.isEnabled = false
                self?.commentView.layer.borderColor = UIColor.gray700.cgColor
            }.disposed(by: disposeBag)

        commentTextView.rx.didChange
            .subscribe { [weak self] _ in
                self?.checkMaxCount(max: 40)
                self?.checkAvailableToDrop()
            }.disposed(by: disposeBag)

        commentTextView.rx.willBeginDragging
            .subscribe { [weak self] _ in
                self?.commentView.layer.borderColor = UIColor.darkPrimary_25.cgColor
            }.disposed(by: disposeBag)

        commentTextView.rx.didEndDragging
            .subscribe { [weak self] _ in
                self?.commentView.layer.borderColor = UIColor.gray700.cgColor
            }.disposed(by: disposeBag)

        commentTextView.rx.text.orEmpty
            .asObservable()
            .bind { [weak self] text in
                guard text != Constant.commentPlaceHolder,
                      !text.isEmpty else { return }
                self?.commentCountLabel.text = "\(text.count)/40"
                self?.commentView.layer.borderColor = text.count < 40
                ? UIColor.darkPrimary_25.cgColor
                : UIColor.systemCritical.cgColor
            }.disposed(by: disposeBag)

        commentClearButton.rx.tap
            .bind { [weak self] in
                self?.commentTextView.text = nil
            }.disposed(by: disposeBag)

        communityGuideButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.endEditing()

                UIView.animate(withDuration: 0.3) {
                    let isHidden: Bool = (self.communityGuideDetailView.alpha == 0)
                    self.communityGuideDetailView.alpha = isHidden ? 1 : 0
                    self.communityGuideDetailView.isUserInteractionEnabled = isHidden ? true : false
                }
            }.disposed(by: disposeBag)

        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind { [weak self] in
                let dismissAction = UIAction {_ in
                    self?.navigationController?.dismiss(animated: true)
                    self?.navigationController?.popToRootViewController(animated: true)
                }

                self?.showAlert(
                    type: .confirm,
                    state: .gray,
                    title: "정말 나가시겠어요? 🥺",
                    subText: "음악과 코멘트 내역은\n자동으로 저장되지 않아요.",
                    buttonTitle: "나가기",
                    buttonAction: dismissAction
                )
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    func bindViewModel() {
        let input = MusicDropViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent.asObservable(),
            keyboardShowEvnet: self.keyboardShowEvent.asObservable(),
            keyboardHideEvnet: self.keyboardHideEvent.asObservable(),
            tapDropButton: self.dropButton.rx.tap.asObservable(),
            comment: self.commentTextView.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.convert(input: input, disposedBag: disposeBag)

        output.locationTitle
            .asDriver(onErrorJustReturn: (address: "", text: ""))
            .drive(onNext: { [weak self] locationTitle in
                self?.locationLabel.attributedText = nil
                self?.locationLabel.text = locationTitle.text
                self?.locationLabel.changeColorPartially(
                    lineHeight: 28,
                    part: locationTitle.address,
                    to: .primary400
                )
                //NSMutableAttributedString속성을 덮어씌우면서 무시되는 textAlignment 설정
                self?.locationLabel.textAlignment = .center
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
            }).disposed(by: disposeBag)

        // 드랍 성공여부
        output.isSuccessDrop
            .asDriver(onErrorJustReturn: (isSuccess: false, toastTitle: nil))
            .drive(onNext: { [weak self] (isSuccess, toastTitle) in
                guard let self = self else { return }

                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })

                    return
                }

                if !isSuccess {
                    self.removeDropAnimation()

                    guard let toastTitle = toastTitle else { return }

                    self.showFailNormalToast(
                        text: toastTitle,
                        bottomInset: 8 + self.dropButton.frame.height + 24,
                        duration: .now() + 5
                    )

                    return
                }
            }).disposed(by: disposeBag)
    }

    //MARK: - UI

    func configureUI() {
        self.view.backgroundColor = .gray900
        self.view.clipsToBounds = true

        [backButton, cancelButton].forEach {
            topView.addSubview($0)
        }

        [commentTextView, commentCountLabel, commentClearButton]
            .forEach {
                commentView.addSubview($0)
            }

        [locationLabel, albumImageView, musicNameLabel, artistLabel, commentView]
            .forEach {
                musicInfoStackView.addArrangedSubview($0)
            }

        [
            musicInfoStackView,
            communityGuideButton,
            dropButton,
            communityGuideDetailView
        ]
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
            $0.height.width.equalTo(32)
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

        musicInfoStackView.setCustomSpacing(2, after: musicNameLabel)
        musicInfoStackView.setCustomSpacing(16, after: albumImageView)
        musicInfoStackView.setCustomSpacing(24, after: artistLabel)

        albumImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(140)
            $0.height.equalTo(self.albumImageView.snp.width)
        }

        musicInfoStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(8)
            $0.leading.trailing.equalToSuperview()
        }

        musicNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(66)
        }

        commentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(112)
        }

        commentTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16+40+4) // inset+countLabel+spacing
        }

        commentClearButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }

        commentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(commentView.snp.trailing).inset(16)
            $0.bottom.equalTo(commentView.snp.bottom).inset(16)
        }

        communityGuideButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(32)
        }

        communityGuideButton.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.centerY.leading.equalToSuperview().inset(12)
            $0.centerY.top.equalToSuperview().inset(8)
            $0.leftMargin.equalTo(4)
        }

        communityGuideDetailView.snp.makeConstraints {
            $0.leading.equalTo(communityGuideButton)
            $0.top.equalTo(communityGuideButton.snp.bottom).offset(8+8) // spacing + 말풍선꼬리높이
        }

        dropButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(contentView.snp.bottom).inset(8)
            $0.height.equalTo(54)
            $0.centerX.equalTo(contentView)
        }
    }
}

// MARK: - UITextViewDelegate

extension MusicDropViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        
        return true
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
            commentTextView.text = String(commentTextView.text.prefix(40))
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
        self.view.addSubview(animationView)

        animationView.snp.makeConstraints {
            $0.width.height.centerY.centerX.equalToSuperview()
        }
    }

    func removeDropAnimation() {
        animationView.snp.removeConstraints()
        self.animationView.removeFromSuperview()
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
        keyboardShowEvent.accept(())
        changeLayoutWhenKeyboardShowAndHide(isKeyboardShow: true)
        scrollView.contentInset.bottom = keyboardFrame.size.height

        UIView.animate(withDuration: 0.3) {
            self.communityGuideDetailView.alpha = 0
            self.communityGuideDetailView.isUserInteractionEnabled = false
        }

        let activeRect = commentTextView.convert(commentTextView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }

    @objc func keyboardWillHide() {
        keyboardHideEvent.accept(())
        changeLayoutWhenKeyboardShowAndHide(isKeyboardShow: false)

        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(.zero, animated: true)
    }

    @objc func endEditing() {
        self.view.endEditing(true)
    }

    //MARK: - 레이아웃 변경
    func changeLayoutWhenKeyboardShowAndHide(isKeyboardShow: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }

            let albumImageLeadingAndTrailing: CGFloat = isKeyboardShow ? 145 : 140

            self.albumImageView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(albumImageLeadingAndTrailing)
                $0.height.equalTo(self.albumImageView.snp.width)
            }
            self.view.layoutIfNeeded()
            //self.musicInfoStackView.layoutIfNeeded()
        }
    }
}
