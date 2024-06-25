//
//  NoticeDetailViewController.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

final class NoticeDetailViewController: UIViewController, Toastable {
    typealias ImageKeyMatch = (key: String, image: UIImage)
    
    private let disposeBag = DisposeBag()
    private let viewModel: DefaultNoticeDetailViewModel
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        return button
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "공지사항"
        label.textColor = UIColor(red: 0.844, green: 0.881, blue: 0.933, alpha: 1)
        label.font = .pretendard(size: 16, weightName: .bold)
        label.setLineHeight(lineHeight: 20)
        return label
    }()
    
    private lazy var titleView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .pretendard(size: 20, weightName: .bold)
        label.setLineHeight(lineHeight: 28)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray200
        label.font = .pretendard(size: 12, weightName: .regular)
        label.setLineHeight(lineHeight: 16)
        return label
    }()
    
    private lazy var markdownTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.linkTextAttributes = [
            .foregroundColor: UIColor(hexString: "#A3F3FA"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: DefaultNoticeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        bindAction()
        bindViewModel()
        
        viewDidLoadEvent.accept(Void())
    }
    
    private func configureTitleView() {
        let titleStackView = UIStackView()
        titleStackView.axis = .vertical
        titleStackView.distribution = .fill
        titleStackView.alignment = .leading
        titleStackView.spacing = 8
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .gray700
        
        [
            titleStackView,
            bottomLineView
        ].forEach {
            self.titleView.addSubview($0)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(titleStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        [
            self.titleLabel,
            self.createdAtLabel
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor.gray900
        
        [
            self.backButton,
            self.navigationTitle
        ].forEach {
            self.navigationBar.addSubview($0)
        }
        
        self.backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        self.navigationTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        
        [
            self.navigationBar,
            scrollView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.navigationBar.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            
            /// 34(safeArea bottom inset) + 30 = 64
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        }
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
            make.height.equalTo(scrollView).priority(.low)
        }
        
        configureTitleView()
        
        [
            self.titleView,
            self.markdownTextView
        ].forEach {
            containerView.addSubview($0)
        }
        
        self.titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.markdownTextView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

extension NoticeDetailViewController {
    func bindAction() {
        Observable.merge(
            self.backButton.rx.tap.asObservable()
        )
        .bind { _ in
            self.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = DefaultNoticeDetailViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable()
        )
        
        let output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.noticeDetail
            .bind { [weak self] noticeDetail in
                self?.displayNoticeDetail(noticeDetail)
            }
            .disposed(by: disposeBag)
    }
    
    private func displayNoticeDetail(_ noticeDetail: NoticeDetail) {
        titleLabel.text = noticeDetail.title
        createdAtLabel.text = noticeDetail.createdAt
        displayMardownString(noticeDetail.content)
    }
}

// MARK: render markdown content

extension NoticeDetailViewController {
    private func displayMardownString(_ markdownString: String) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let attributedText = try await self.renderMarkdownContent(in: markdownString)
                await MainActor.run {
                    self.markdownTextView.attributedText = attributedText
                }
            } catch {
                print("Failed to convert markdown:", error)
            }
        }
    }
    
    private func renderMarkdownContent(in markdownString: String) async throws -> NSAttributedString {
        let (replacedMarkdownString, imageMatches) = try await loadImages(in: markdownString)
        var options = AttributedString.MarkdownParsingOptions(
            interpretedSyntax: .inlineOnlyPreservingWhitespace
        )
        options.allowsExtendedAttributes = true
        let convertedString = try AttributedString(
            markdown: replacedMarkdownString, 
            options: options
        )
        var mutableString = NSMutableAttributedString(convertedString)
        applyImageAttachments(to: &mutableString, with: imageMatches)
        applyTextStyle(&mutableString)
        return mutableString
    }
    
    private func loadImages(in string: String) async throws -> (String, [ImageKeyMatch]) {
        let regex = try NSRegularExpression(pattern: "!\\[.*?\\]\\((.*?)\\)")
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, range: fullRange)
        
        let imageKeyFormat = "{StreetDrop.NoticeImage.%d}"
        var replacedString = string
        var imageMatches: [ImageKeyMatch] = .init()
        for (index, match) in matches.reversed().enumerated() {
            let imageKey = String(format: imageKeyFormat, index)
            guard let urlRange = Range(match.range(at: 1), in: string),
                  let image = try? await UIImage.load(with: String(string[urlRange]))
            else { continue }
            
            replacedString = (replacedString as NSString).replacingCharacters(
                in: match.range,
                with: imageKey
            )
            imageMatches.append((key: imageKey, image: image))
        }
        return (replacedString, imageMatches)
    }
    
    private func applyImageAttachments(
        to mutableString: inout NSMutableAttributedString,
        with imageMatches: [ImageKeyMatch]
    ) {
        for match in imageMatches {
            guard let range = mutableString.string.range(of: match.key) else { continue }
            let nsRange = NSRange(range, in: mutableString.string)
            
            let textAttachment = NSTextAttachment()
            let image = imageWithRoundedCorners(image: match.image, radius: 12) ?? match.image
            guard let cgImage = image.cgImage else {
                mutableString.replaceCharacters(in: nsRange, with: "")
                continue
            }
            textAttachment.image = UIImage(
                cgImage: cgImage,
                scale: image.size.width / (markdownTextView.frame.size.width),
                orientation: .up
            )
            
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            mutableString.replaceCharacters(in: nsRange, with: attrStringWithImage)
        }
    }
    
    private func imageWithRoundedCorners(image: UIImage, radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        image.draw(in: rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }

    private func applyTextStyle(_ mutableString: inout NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 20
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 14, weightName: .regular),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        mutableString.addAttributes(
            defaultAttributes,
            range: NSRange(location: 0, length: mutableString.length)
        )
    }
}
