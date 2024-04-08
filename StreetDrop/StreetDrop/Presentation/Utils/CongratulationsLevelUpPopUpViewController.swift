//
//  CongratulationsLevelUpPopUpViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 4/3/24.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay
import Lottie

final class CongratulationsLevelUpPopUpViewController: UIViewController {
    private let contentTitle: String
    private let contentDescription: String
    private let popupName: String
    private let remainCount: Int?
    private let disposedBag: DisposeBag = .init()
    let closeButtonEvent: PublishRelay<Void> = .init()
    
    init(
        contentTitle: String,
        contentDescription: String,
        popupName: String,
        remainCount: Int?
    ) {
        self.contentTitle = contentTitle
        self.contentDescription = contentDescription
        self.popupName = popupName
        self.remainCount = remainCount
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray700
        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        return view
    }()
    
    private lazy var congratulationLabel: GradientLabel = {
        let gradientLabel: GradientLabel = .init(
            colors: [
                UIColor(hexString: "#B0C6FF"),
                UIColor(hexString: "#CBB3FF"),
                UIColor(hexString: "#71FFF6"),
                UIColor(hexString: "#F7F7F7"),
                UIColor(hexString: "#DCCCFF")
            ],
            locations: [
                0.1034,
                0.2517,
                0.5688,
                0.7459,
                0.8941
            ]
        )
        gradientLabel.text = contentTitle
        gradientLabel.numberOfLines = 2
        gradientLabel.font = .pretendard(size: 20, weightName: .bold)
        gradientLabel.setLineHeight(lineHeight: 28)
        
        return gradientLabel
    }()
    
    private lazy var levelUpImageView: UIImageView = {
        var imageName: String = ""
        switch popupName {
        case "LEVEL_2":
            imageName = "level_2_image"
        case "LEVEL_3":
            imageName = "level_3_image"
        default:
            break
        }
        
        let imageView: UIImageView = .init(image: .init(named: imageName))
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = UIColor.gray50
        label.text = contentDescription
        label.numberOfLines = 2
        label.setLineHeight(lineHeight: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weightName: .medium)
        button.backgroundColor = .gray200
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private lazy var remainCountLabel: UILabel = {
        let label: UILabel = .init()
        label.isHidden = remainCount == nil
        label.font = .pretendard(size: 12, weight: 500)
        label.textColor = .gray300
        
        let fullText: String = "다음 레벨까지 \(remainCount ?? 0)개"
        if let remainCount = remainCount,
           let range = fullText.range(of: "\(remainCount)개") {
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = 20
            style.minimumLineHeight = 20
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (20 - label.font.lineHeight) / 4
            ]
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
            
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(hexString: "#68EBF7"), range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.pretendard(size: 12, weight: 700), range: nsRange)
            
            label.attributedText = attributedString
        }
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        configureUI()
    }
}

private extension CongratulationsLevelUpPopUpViewController {
    func bindAction() {
        closeButton.rx.tap
            .bind(to: closeButtonEvent)
            .disposed(by: disposedBag)
    }
    
    func configureUI() {
        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        view.addSubview(containerView)
        [
            congratulationLabel,
            levelUpImageView,
            descriptionLabel,
            closeButton,
            remainCountLabel
        ].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(294)
            $0.height.equalTo(remainCount == nil ? 376 : 408)
            $0.center.equalToSuperview()
        }
        
        congratulationLabel.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(56)
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        levelUpImageView.snp.makeConstraints {
            $0.width.equalTo(129)
            $0.height.equalTo(110)
            $0.top.equalTo(congratulationLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(40)
            $0.top.equalTo(levelUpImageView.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(44)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        remainCountLabel.snp.makeConstraints {
            $0.width.equalTo(238)
            $0.height.equalTo(20)
            $0.top.equalTo(closeButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
    }
}
