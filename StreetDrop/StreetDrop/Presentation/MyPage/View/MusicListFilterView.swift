//
//  MusicListFilterView.swift
//  StreetDrop
//
//  Created by thoonk on 7/18/24.
//

import UIKit

import RxSwift

final class MusicListFilterView: UIView {
    
    fileprivate let musicCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 0개"
        label.textColor = .gray200
        label.font = .pretendard(size: 14, weightName: .regular)
        return label
    }()
    
    fileprivate let sortFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weightName: .regular)
        button.setImage(UIImage(named: "icon-arrow-down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft

        return button
    }()

    fileprivate let regionFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("필터", for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weightName: .regular)
        button.setImage(UIImage(named: "icon-filter"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
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
}

// MARK: - Private Methods

private extension MusicListFilterView {
    func configureUI() {
        backgroundColor = .gray900
        
        addSubview(musicCountLabel)
        musicCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        addSubview(regionFilterButton)
        regionFilterButton.snp.makeConstraints {
            $0.top.bottom.equalTo(musicCountLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        addSubview(sortFilterButton)
        sortFilterButton.snp.makeConstraints {
            $0.top.bottom.equalTo(musicCountLabel)
            $0.trailing.equalTo(regionFilterButton.snp.leading).offset(-16)
        }
    }
}

// MARK: - MusicListFilterView + Rx

extension Reactive where Base: MusicListFilterView {
    var setMusicCountText: Binder<Int> {
        Binder(base) { base, totalCount in
            base.musicCountLabel.text = "총 \(totalCount)개"
        }
    }
    
    var onSortFilterTap: Observable<Void> {
        base.sortFilterButton.rx.tap.mapVoid()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
    }
    
    var onRegionFilterTap: Observable<Void> {
        base.sortFilterButton.rx.tap.mapVoid()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
    }
}
