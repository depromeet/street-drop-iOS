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
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    
    let modalContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        
        return view
    }()
    
    private let regionFilterLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "지역 필터"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 28, weight: 700)
        label.setLineHeight(lineHeight: 28)
        
        label.textAlignment = .center
        
        return label
    }()
    
    private let line: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray600
        
        return view
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
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.backgroundColor = .gray900
        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        
        return tableView
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
            regionFilterLabel,
            line,
            collectionView
        ].forEach {
            modalContainerView.addSubview($0)
        }
        
        regionFilterLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.horizontalEdges.equalToSuperview().inset(24)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(regionFilterLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
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
        dataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: StateTableViewCell.identifier,
                    for: indexPath
                ) as? StateTableViewCell else { return UITableViewCell() }
                cell.configure(regionName: "테스트")
                
                return cell
            }
        )
        
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
