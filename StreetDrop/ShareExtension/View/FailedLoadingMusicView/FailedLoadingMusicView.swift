//
//  FailedLoadingMusicView.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/20/24.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit

final class FailedLoadingMusicView: UIView {
    private let searchingMusicButtonEventRelay: PublishRelay<Void> = .init()
    var searchingMusicButtonEvent: Observable<Void> {
        searchingMusicButtonEventRelay.asObservable()
    }
    
    private let disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindAction()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let warningImageView: UIImageView = .init(image: .init(named: "warning"))
    
    private let guidingLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "음악 정보를 불러오지 못했어요"
        label.font = .pretendard(size: 18, weight: 700)
        label.textColor = .white
        label.setLineHeight(lineHeight: 28)
        
        return label
    }()
    
    private let searchingMusicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("음악 검색하기", for: .normal)
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: 700)
        button.layer.cornerRadius = 12
        button.backgroundColor = .primary400

        return button
    }()
}

private extension FailedLoadingMusicView {
    func bindAction() {
        searchingMusicButton.rx.tap
            .bind(to: searchingMusicButtonEventRelay)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray600.cgColor
        
        backgroundColor = .gray800
        
        snp.makeConstraints {
            $0.height.equalTo(192)
        }
        
        [
            warningImageView,
            guidingLabel,
            searchingMusicButton
        ].forEach {
            addSubview($0)
        }
        
        warningImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        guidingLabel.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(warningImageView.snp.trailing)
        }
        
        searchingMusicButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
}
