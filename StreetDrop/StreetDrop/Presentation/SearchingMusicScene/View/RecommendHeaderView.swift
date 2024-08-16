//
//  RecommendHeaderView.swift
//  StreetDrop
//
//  Created by jihye kim on 09/08/2024.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

class RecommendHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    let titleLabel = UILabel()
    let arrowIconImageView = UIImageView()
    let infoIconButton = UIButton()
    private let disposeBag: DisposeBag = DisposeBag()
    private let infoGuideView = GuideDetailView()
    
    private var didTapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let tapAreaView = UIView()
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )
        tapAreaView.addGestureRecognizer(tapGesture)
        
        addSubview(tapAreaView)
        tapAreaView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        titleLabel.font = .pretendard(size: 20, weightName: .bold)
        titleLabel.textColor = .white
        
        tapAreaView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        arrowIconImageView.image = UIImage(named: "goTo")
        tapAreaView.addSubview(arrowIconImageView)
        
        arrowIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        infoIconButton.setImage(
            UIImage(named: "infoIcon")?
                .resized(to: CGSize(width: 20, height: 20))?
                .withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        infoIconButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.infoIconButton.isSelected.toggle()
                let isSelected = self.infoIconButton.isSelected
                self.infoIconButton.tintColor = isSelected ? .primary400 : .gray200
                
                UIView.animate(withDuration: 0.3) {
                    self.infoGuideView.alpha = isSelected ? 1 : 0
                    self.infoGuideView.isUserInteractionEnabled = isSelected
                }
            },
            for: .touchUpInside
        )
        infoIconButton.tintColor = .gray200
        addSubview(infoIconButton)
        
        infoIconButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        addSubview(infoGuideView)
        infoGuideView.snp.makeConstraints { make in
            make.trailing.equalTo(infoIconButton).offset(7)
            make.top.equalTo(infoIconButton.snp.bottom).offset(16)
        }
    }
    
    @objc private func didTap() {
        self.didTapAction?()
    }
    
    func configure(
        with title: String,
        hideArrow: Bool = false,
        infoText: String? = nil,
        didTapAction: (() -> Void)? = nil
    ) {
        self.titleLabel.text = title
        self.arrowIconImageView.isHidden = hideArrow
        self.didTapAction = didTapAction
        
        if let infoText {
            self.infoIconButton.isHidden = false
            infoGuideView.configureText(infoText)
        } else {
            self.infoIconButton.isHidden = true
        }
    }
}
