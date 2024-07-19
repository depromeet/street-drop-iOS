//
//  TapListView.swift
//  StreetDrop
//
//  Created by thoonk on 7/18/24.
//

import UIKit

import RxSwift

final class TapListView: UIView {
    
    fileprivate let dropTapButton: UIButton = {
        let button = UIButton()
        button.setTitle("드랍", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        return button
    }()
    
    fileprivate let likeTapButton: UIButton = {
        let button = UIButton()
        button.setTitle("좋아요", for: .normal)
        button.setTitleColor(UIColor.gray400, for: .normal)
        button.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
        button.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTapListUI(by type: MyMusicType) {
        switch type {
        case .drop:
            dropTapButton.setTitleColor(.white, for: .normal)
            dropTapButton.setTitleColor(.lightGray, for: .highlighted)
            dropTapButton.setTitleColor(.white, for: .normal)
            dropTapButton.setTitleColor(.lightGray, for: .highlighted)
            likeTapButton.setTitleColor(UIColor.gray400, for: .normal)
            likeTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            likeTapButton.setTitleColor(UIColor.gray400, for: .normal)
            likeTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            
        case.like:
            dropTapButton.setTitleColor(UIColor.gray400, for: .normal)
            dropTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            dropTapButton.setTitleColor(UIColor.gray400, for: .normal)
            dropTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            likeTapButton.setTitleColor(.white, for: .normal)
            likeTapButton.setTitleColor(.lightGray, for: .highlighted)
            likeTapButton.setTitleColor(.white, for: .normal)
            likeTapButton.setTitleColor(.lightGray, for: .highlighted)
        }
    }
}

// MARK: - Private Methods

private extension TapListView {
    func configureUI() {
        backgroundColor = .gray900
        
        addSubview(dropTapButton)
        dropTapButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(35)
        }
        
        addSubview(likeTapButton)
        likeTapButton.snp.makeConstraints {
            $0.top.bottom.equalTo(dropTapButton)
            $0.leading.equalTo(dropTapButton.snp.trailing).offset(20)
            $0.width.equalTo(52)
        }
    }
}

// MARK: - TapListView + Rx

extension Reactive where Base: TapListView {
    var onDropTap: Observable<Void> {
        base.dropTapButton.rx.tap.mapVoid()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
    }

    var onLikeTap: Observable<Void> {
        base.likeTapButton.rx.tap.mapVoid()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
    }
}
