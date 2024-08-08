//
//  RegionFilteringModalViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class RegionFilteringModalViewController: UIViewController, ModalPresentable {
    var upperMarginHeight: CGFloat = 158
    var containerViewTopConstraint: Constraint?
    let disposeBag: DisposeBag = .init()
    private let viewModel: RegionFilteringModalViewModel = .init()
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    let modalContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        
        return view
    }()
    
    private let filterLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "필터"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 28, weight: 700)
        label.setLineHeight(lineHeight: 28)
        
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "전체 지역"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 14, weight: 400)
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "arrow-right-primary"))
        
        return imageView
    }()
    
    private let districtLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "시/군/구"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 14, weight: 400)
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModal()
        configureDataSource()
        bindViewModel()
        configureUI()
    }
}

private extension RegionFilteringModalViewController {
    func bindViewModel() {
        let input: RegionFilteringModalViewModel.Input = .init(
            viewDidLoadEvent: .just(Void())
        )
        
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.cityNames
            .bind(with: self) { owner, cityNames in
                owner.displayCityNames(cityNames)
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [
            filterLabel,
            cityLabel,
            arrowImageView,
            districtLabel,
            collectionView
        ].forEach {
            modalContainerView.addSubview($0)
        }
        
        filterLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.horizontalEdges.equalToSuperview().inset(24)
        }
        
        cityLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(filterLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(cityLabel)
            $0.leading.equalTo(cityLabel.snp.trailing)
        }
        
        districtLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.centerY.equalTo(cityLabel)
            $0.leading.equalTo(arrowImageView.snp.trailing)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
    }
    
    func displayCityNames(_ cityNames: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(cityNames, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Collection View

extension RegionFilteringModalViewController: UICollectionViewDelegate {
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 3.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 6, bottom: 0, trailing: 6)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(48)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            
            return section
        }
    }
    
    private func configureDataSource() {
        typealias CellRegistration = UICollectionView.CellRegistration<RegionCollectionViewCell, String>
        let cellRegistration = CellRegistration { cell, indexPath, item in
            cell.configure(regionName: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, String>(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
}
