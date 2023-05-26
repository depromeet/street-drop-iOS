//
//  RecentMusicSearchScrollView.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/24.
//

import UIKit

import RxRelay

final class RecentMusicSearchScrollView: UIView {
    let queryButtonDidTappedEvent: PublishRelay = PublishRelay<String>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(queries: [String]) {
        queries.enumerated().forEach { (index, query) in
            let recentQueryButton = RecentQueryButton()
            recentQueryButton.query = query
            recentQueryButton.rx.controlEvent(.touchUpInside)
                .bind {
                    print(query)
                }
            self.stackView.addArrangedSubview(recentQueryButton)
            recentQueryButton.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
            }
        }
    }
}

private extension RecentMusicSearchScrollView {
    func setupLayout() {
        self.scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        
        self.stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.height.equalToSuperview()
        }
    }
}
