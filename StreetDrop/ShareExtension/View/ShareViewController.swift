//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/12/24.
//

import UIKit
import Social
import SafariServices

import Kingfisher
import RxSwift
import RxRelay
import SnapKit

final class ShareViewController: UIViewController {
    enum Constant {
        static let commentPlaceHolder: String = "노래, 현재 감정, 상황, 관련 에피소드, 거리, 가수 등 떠오르는 말을 적어보세요."
        static let communityButtonTitle: String = "커뮤니티 가이드"
        static let defaultCommentCount: String = "0/40"
    }
    private let viewModel: ShareViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private let sharedMusicKeyWordEvent: PublishRelay<String> = .init()
    
    private let containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray600.cgColor
        
        return view
    }()
    
    private let villageNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.font = .pretendard(size: 16, weight: 700)
        label.textColor = .primary400
        label.setLineHeight(lineHeight: 24)
        
        return label
    }()
    
    private let changingMusicView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray600
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "#363840").cgColor
        
        let label: UILabel = .init()
        label.text = "원하는 음악이 아닌가요?"
        label.font = .pretendard(size: 14, weight: 500)
        label.textColor = .gray150
        label.setLineHeight(lineHeight: 20)
        
        let imageView: UIImageView = .init(image: .init(named: "next"))
        
        [label, imageView].forEach {
            view.addSubview($0)
        }
        label.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(10)
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        return view
    }()
    
    private let belowArrow: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "verctor"))
        
        return imageView
    }()
    
    private let albumCoverImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.font = .pretendard(size: 16, weight: 700)
        label.textColor = .textPrimary
        label.setLineHeight(lineHeight: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = " "
        label.textColor = .gray400
        label.font = .pretendard(size: 12, weight: 400)
        label.setLineHeight(lineHeight: 16)
        label.textAlignment = .center
        
        return label
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
    
    private lazy var communityGuideDetailView: CommunityGuideDetailView = .init()
    
    private let dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("드랍하기", for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .bold)
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray300
        button.isEnabled = false

        return button
    }()
    
    private let dropButtonOnKeyBoard: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("드랍하기", for: .normal)
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: 700)
        button.backgroundColor = .primary500
        button.isEnabled = false
        button.isHidden = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bindViewModel()
        configureUI()
        registerKeyboardNotification()
        
        // 공유된 데이터 가져오기
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        handleExtensionItem(extensionItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPlaceHolder()
    }
}

private extension ShareViewController {
    func bindAction() {
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
                self?.checkAvailableToDrop()
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
        
        communityGuideDetailView.shareExtensionCompletionEvent
            .bind(with: self) { owner, url in
                let safariVC = SFSafariViewController(url: url)
                owner.present(safariVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
            
    }
    
    func bindViewModel() {
        let input: ShareViewModel.Input = .init(
            viewDidLoadEvent: .just(Void()),
            sharedMusicKeyWordEvent: sharedMusicKeyWordEvent.asObservable()
        )
        let output: ShareViewModel.Output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.showVillageName
            .bind(with: self) { owner, villageName in
                owner.villageNameLabel.text = villageName
            }
            .disposed(by: disposeBag)
        
        output.showSearchedMusic
            .bind(with: self) { owner, music in
                owner.albumCoverImageView.kf.setImage(with: URL(string: music.albumImage))
                owner.songNameLabel.text = music.songName
                owner.artistNameLabel.text = music.artistName
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.addSubview(containerView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(596)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        [
            dropButton,
            villageNameLabel,
            changingMusicView,
            belowArrow,
            albumCoverImageView,
            songNameLabel,
            artistNameLabel,
            commentView,
            communityGuideButton,
            communityGuideDetailView,
            dropButtonOnKeyBoard
        ].forEach {
            containerView.addSubview($0)
        }
        
        [
            commentTextView,
            commentCountLabel,
            commentClearButton
        ].forEach {
            commentView.addSubview($0)
        }
        
        villageNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        changingMusicView.snp.makeConstraints {
            $0.width.equalTo(174)
            $0.height.equalTo(28)
            $0.top.equalTo(villageNameLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        belowArrow.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(6)
            $0.top.equalTo(changingMusicView.snp.bottom)
            $0.centerX.equalTo(changingMusicView)
        }
        
        albumCoverImageView.snp.makeConstraints {
            $0.width.height.equalTo(85)
            $0.top.equalTo(belowArrow.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        songNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(albumCoverImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(songNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(24)
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
            $0.width.equalTo(120)
            $0.height.equalTo(32)
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(commentView.snp.bottom).offset(16)
        }
        
        communityGuideDetailView.snp.makeConstraints {
            $0.leading.equalTo(communityGuideButton)
            $0.top.equalTo(communityGuideButton.snp.bottom).offset(8+8) // spacing + 말풍선꼬리높이
        }
        
        dropButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        dropButtonOnKeyBoard.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

// MARK: - Handle Shared Data
private extension ShareViewController {
    func handleExtensionItem(_ extensionItem: NSExtensionItem) {
        // ExtensionItem에서 ContentText 추출
        guard let sharedTextItem = extensionItem.attributedContentText,
              let videoID = extractVideoID(from: sharedTextItem.string) else { return }
        
        fetchVideoDetails(videoID: videoID) { [weak self] songName, artistName in
            self?.sharedMusicKeyWordEvent.accept("\(songName ?? "")-\(artistName ?? "")")
        }
    }
    
    func fetchVideoDetails(videoID: String, completion: @escaping (String?, String?) -> Void) {
        let apiKey = "AIzaSyDHsdIcuAK98-EW9UueCeF6g4iYiap7bmA" // YouTube Data API 키를 여기에 입력하세요
        let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(videoID)&key=\(apiKey)&part=snippet"
        
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]],
                   let snippet = items.first?["snippet"] as? [String: Any] {
                    let title = snippet["title"] as? String
                    let channelTitle = snippet["channelTitle"] as? String
                    completion(title, channelTitle)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func extractVideoID(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
    
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
            [dropButton, dropButtonOnKeyBoard].forEach {
                $0.isEnabled = true
                $0.backgroundColor = .primary500
                $0.setTitleColor(.gray900, for: .normal)
            }
        } else {
            [dropButton, dropButtonOnKeyBoard].forEach {
                $0.isEnabled = false
                $0.setTitleColor(
                    .gray400,
                    for: .normal
                )
                $0.backgroundColor = .gray300
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension ShareViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        
        return true
    }
}

// MARK: - KeyBoard
private extension ShareViewController {
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
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            containerView.snp.updateConstraints { [weak self] in
                guard let self = self else { return }

                $0.height.equalTo(view.bounds.height)
            }
            
            communityGuideDetailView.alpha = 0
            communityGuideDetailView.isUserInteractionEnabled = false
            
            view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: { [weak self] in
            guard let self = self,
                  let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
            // 키보드의 위치에 맞게 버튼 위치 조정
            let keyboardHeight = keyboardFrame.cgRectValue.height
            dropButtonOnKeyBoard.isHidden = false
            checkAvailableToDrop()
            dropButtonOnKeyBoard.frame.origin.y = view.frame.height - keyboardHeight - 56
        })
        
    }

    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerView.snp.updateConstraints {
                $0.height.equalTo(596)
            }
            self?.dropButtonOnKeyBoard.isHidden = true
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
}
