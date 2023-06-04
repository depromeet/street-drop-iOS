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
    private var viewModel: MusicDropViewModel
    private let disposeBag: DisposeBag = DisposeBag()

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
        viewModel.fetchAlbumImage()
        viewModel.fetchAdress()
        bindAction()
        bindViewModel()
        bindCommentTextView()
        registerKeyboardNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        makeViewIntoGradientCircle()
    }

    //MARK: - UI

    // 디자인 요소 (레이아웃 잡힌 후 그라데이션 layer 적용)
    private lazy var topGradientCircleView: UIView = UIView()
    private lazy var smallerCenterGradientCircleView: UIView = UIView()
    private lazy var LargerCenterGradientCircleView: UIView = UIView()

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
        button.setTitle("취소", for: .normal)
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
        label.text = Constant.textDefault
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 32)

        return label
    }()

    private lazy var albumImageView: UIImageView = {
        let loadingImage = UIImage(systemName: "slowmo")
        let imageView = UIImageView(image: loadingImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var albumImageGradationView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(red: 0.399, green: 0.375, blue: 0.833, alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = true // true로 지정 후, 코멘트 작성시 false로 바뀜

        return view
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
        label.textColor = .white
        label.font = .pretendard(size: 12, weight: 500)
        label.setLineHeight(lineHeight: 18)

        return label
    }()

    private lazy var musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5

        return stackView
    }()

    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .pretendard(size: 14, weight: 500)
        textView.backgroundColor = UIColor(red: 0.213, green: 0.213, blue: 0.213, alpha: 1)
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 12, left: 14, bottom: 12, right: 14)
        textView.keyboardAppearance = .dark
        textView.showsVerticalScrollIndicator = false
        textView.sizeToFit()
        textView.isScrollEnabled = false

        return textView
    }()

    private lazy var CommentGuidanceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Constant.textDefault
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .pretendard(size: 11, weight: 400)
        label.setLineHeight(lineHeight: 17)
        
        return label
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }()

    private lazy var dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(red: 0.335, green: 0.338, blue: 0.35, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0.225, green: 0.224, blue: 0.25, alpha: 1)
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

extension MusicDropViewController {

    // MARK: - Action Binding

    private func bindAction() {
        dropButton.rx.tap
            .bind {
                self.touchedUpDropButton()
            }.disposed(by: disposeBag)
    }

    // MARK: - Data Binding

    private func bindViewModel() {
        viewModel.locationTitle.subscribe { [weak self] in
            if let element: (adress: String, text: String) = $0.element {
                self?.locationLabel.text = element.text
                self?.locationLabel.attributedText = element.text.changeColorPartially(
                    element.adress,
                    to: UIColor(red: 145/255, green: 141/255, blue: 255/255, alpha: 1)
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

        viewModel.commentPlaceHolder.subscribe { [weak self] in
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

    //MARK: - UI

    private func configureUI() {
        [backButton, cancelButton].forEach {
            topView.addSubview($0)
        }

        albumImageGradationView.addSubview(albumImageView)

        [locationLabel, dropGuideLabel, albumImageGradationView, musicNameLabel, artistLabel]
            .forEach {
                musicInfoStackView.addArrangedSubview($0)
            }

        [commentTextView, CommentGuidanceLabel]
            .forEach {
                commentStackView.addArrangedSubview($0)
            }

        [musicInfoStackView, commentStackView, dropButton]
            .forEach {
                self.contentView.addSubview($0)
            }

        scrollView.addSubview(contentView)

        // 디자인요소인 GradientCircleView들 먼저 add합니다. 순서 변경 불가능합니다.
        [
            LargerCenterGradientCircleView,
            smallerCenterGradientCircleView,
            topGradientCircleView,
            topView,
            scrollView
        ]
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
            $0.trailing.equalToSuperview().inset(19.5)
            $0.centerY.equalToSuperview()
        }

        topGradientCircleView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(1.1)
            $0.height.equalTo(topGradientCircleView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.2)
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

        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.top.equalTo(topView.snp.bottom)
        }

        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView)
        }

        albumImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

        albumImageGradationView.snp.makeConstraints {
            $0.width.equalTo(contentView).multipliedBy(0.30)
            $0.height.equalTo(albumImageView.snp.width)
        }

        musicInfoStackView.setCustomSpacing(32, after: dropGuideLabel)
        musicInfoStackView.setCustomSpacing(16, after: albumImageView)

        musicInfoStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(contentView).inset(20)
            $0.centerX.equalTo(contentView)
        }

        commentStackView.snp.makeConstraints {
            $0.top.equalTo(musicInfoStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(24)
            $0.height.greaterThanOrEqualTo(contentView).multipliedBy(0.1)
            //$0.bottom.equalTo(contentView).inset(30)
            $0.centerX.equalTo(contentView)
        }

        dropButton.snp.makeConstraints {
            $0.width.equalTo(commentTextView)
            $0.bottom.equalTo(contentView.snp.bottom).inset(30)
            $0.height.equalTo(54)
            $0.centerX.equalTo(contentView)
        }
    }
}

//MARK: - private
private extension MusicDropViewController {

    //MARK: - 코멘트 플레이스홀더, 텍스트 줄 수에 맞게 변하는 다이나믹 TextView, 줄 수 제한, 커멘트있을때만 드랍가능

    func bindCommentTextView() {
        commentTextView.rx.didBeginEditing
            .subscribe { [weak self] element in
                self?.removePlaceHolder()
                self?.commentTextView.sizeToFit()
            }.disposed(by: disposeBag)

        commentTextView.rx.didEndEditing
            .subscribe { [weak self] element in
                self?.setupPlaceHolder()
            }.disposed(by: disposeBag)

        commentTextView.rx.didChange
            .subscribe { [weak self] _ in
                self?.checkMaxNumberOfLines(max: 4)
                self?.checkAvailableToDrop()
            }.disposed(by: disposeBag)
    }

    func setupPlaceHolder() {
        var placeHolder: String?

        viewModel.commentPlaceHolder
            .subscribe {
                placeHolder = $0
            }.disposed(by: disposeBag)

        if(commentTextView.text == nil || commentTextView.text == "") {
            commentTextView.text = placeHolder
            commentTextView.textColor = UIColor(red: 0.587, green: 0.587, blue: 0.587, alpha: 1)
        }
    }

    func removePlaceHolder() {
        var placeHolder: String?

        viewModel.commentPlaceHolder
            .subscribe {
                placeHolder = $0
            }.disposed(by: disposeBag)

        if(commentTextView.text == placeHolder) {
            commentTextView.text = nil
            commentTextView.textColor = .white
        }
    }

    func checkMaxNumberOfLines(max: Int) {
        let lineBreakCharacter = "\n"
        let lines = commentTextView.text.components(separatedBy: lineBreakCharacter).count

        if lines > max {
            commentTextView.text = String(commentTextView.text.dropLast())
        }
    }

    func checkAvailableToDrop() {
        var placeHolder: String?

        viewModel.commentPlaceHolder
            .subscribe {
                placeHolder = $0
            }.disposed(by: disposeBag)

        if(commentTextView.text != nil
           && commentTextView.text != ""
           && commentTextView.text != placeHolder
        ) {
            albumImageGradationView.layer.masksToBounds = false
            dropButton.isEnabled = true
            dropButton.backgroundColor = UIColor(red: 0.399, green: 0.371, blue: 1, alpha: 1)
            dropButton.setTitleColor(.white, for: .normal)
        } else {
            albumImageGradationView.layer.masksToBounds = true
            dropButton.isEnabled = false
            dropButton.setTitleColor(
                UIColor(red: 0.335, green: 0.338, blue: 0.35, alpha: 1),
                for: .normal
            )
            dropButton.backgroundColor = UIColor(red: 0.225, green: 0.224, blue: 0.25, alpha: 1)
        }
    }

    //MARK: - 드랍 액션

    func touchedUpDropButton() {
        self.viewModel.drop(content: self.commentTextView.text ?? "")
        // 👉TODO - 애니메이션 추갸하기, 1초정도 보여준 후 VC 네비게이션바에서 pop하기
        self.showDropAnimation()
    }

    func showDropAnimation() {
        removeViewItemComponents()

        self.view.addSubview(dropAnimationImageView)
        dropAnimationImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
    }

    func removeViewItemComponents() {
        scrollView.removeFromSuperview()
    }

    //MARK: - 그라데이션 뷰

    func makeViewIntoGradientCircle() {
        topGradientCircleView.makeGradientCircleView(
            colors: [
                UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1).cgColor,
                UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 0.61).cgColor,
                UIColor(red: 0.208, green: 0.207, blue: 0.292, alpha: 1).cgColor,
            ],
            gradientLocations: [0, 0.5, 1],
            viewBackgroundColor: .black,
            startPoint: CGPoint(x: 0.5, y: 0.25),
            endPoint: CGPoint(x: 0.5, y: 0.75)
        )

        [smallerCenterGradientCircleView, LargerCenterGradientCircleView].forEach {
            $0.makeGradientCircleView(
                colors: [
                    UIColor.primaryBackground.cgColor,
                    UIColor.primaryBackground.cgColor,
                    UIColor(red: 145/255, green: 141/255, blue: 255/255, alpha: 1).cgColor
                ],
                gradientLocations: [0, 0.8, 1],
                viewBackgroundColor: .primaryBackground,
                startPoint: CGPoint(x: 0.5, y: 0),
                endPoint:  CGPoint(x: 0.5, y: 1)
            )
        }
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

        let activeRect = CommentGuidanceLabel.convert(CommentGuidanceLabel.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }

    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - Constant
extension MusicDropViewController {
    enum Constant {
        static let textDefault: String = " "
    }
}
