//
//  RecommendMusicSearchScrollView.swift
//  StreetDrop
//
//  Created by Jieun Kim on 2023/10/15.
//

import UIKit
import RxRelay
import RxSwift

final class RecommendMusicSearchCollectionView: UIView {
    let queryButtonDidTappedEvent: PublishRelay = PublishRelay<String>()
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var musicData = [RecommendMusicData]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(queries: [RecommendMusicData]) {
        musicData = queries
        
        queries.enumerated().forEach { (index, query) in
            let recentQueryButton = RecentQueryButton()
            recentQueryButton.rx.controlEvent(.touchUpInside)
                .bind { [weak self] in
                    self?.queryButtonDidTappedEvent.accept(query.text)
                }
                .disposed(by: disposeBag)
        }
        self.configureUI()
    }
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecommendKeywordItemCell.self, forCellWithReuseIdentifier: RecommendKeywordItemCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
}

extension RecommendMusicSearchCollectionView {
    func configureUI() {
        self.addSubview(collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.height.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension RecommendMusicSearchCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.queryButtonDidTappedEvent.accept(musicData[indexPath.item].text)
    }
}

// MARK: - UICollectionViewDataSource
extension RecommendMusicSearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendKeywordItemCell.cellIdentifier, for: indexPath) as? RecommendKeywordItemCell else {
            fatalError("Could not make new cell")
        }
        
        cell.configure(data: musicData[indexPath.item])
        return cell
    }
}

extension RecommendMusicSearchCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label: UILabel = {
            let label = UILabel()
            label.font = .pretendard(size: 16, weightName: .medium)
            label.text = musicData[indexPath.item].text
            label.layer.cornerRadius = 16
            label.sizeToFit()
            return label
        }()
        
        let size = label.frame.size
        return CGSize(width: size.width + 32, height: size.height + 16)
    }
}
