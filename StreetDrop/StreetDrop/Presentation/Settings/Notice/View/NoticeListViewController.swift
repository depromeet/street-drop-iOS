//
//  NoticeListViewController.swift
//  StreetDrop
//
//  Created by jihye kim on 15/06/2024.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

final class NoticeListViewController: UIViewController, Toastable {
    private let disposeBag = DisposeBag()
    private let viewModel: DefaultNoticeListViewModel
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Notice>!
    
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: DefaultNoticeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        configureDataSource()
        
        bindAction()
        bindViewModel()
        
        viewDidLoadEvent.accept(Void())
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor.gray900
        
        [
            self.backButton,
            self.navigationTitle
        ].forEach {
            self.navigationBar.addSubview($0)
        }
        
        [
            self.navigationBar
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.navigationBar.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        self.backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        self.navigationTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: CollectionView

extension NoticeListViewController: UICollectionViewDelegate {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(93)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(93)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 24,
                bottom: 24,
                trailing: 24
            )
            
            return section
        }
    }
    
    private func configureDataSource() {
        typealias CellRegistration = UICollectionView.CellRegistration<NoticeListCell, Notice>
        let cellRegistration = CellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Notice>(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let notice = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let noticeDetailViewController = NoticeDetailViewController(
            viewModel: .init(noticeId: notice.announcementId)
        )
        self.navigationController?.pushViewController(
            noticeDetailViewController,
            animated: true
        )
    }
}

extension NoticeListViewController {
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
        let input = DefaultNoticeListViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable()
        )
        
        let output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.noticeList
            .bind { [weak self] noticeList in
                self?.displayNoticeList(noticeList)
            }
            .disposed(by: disposeBag)
    }
    
    private func displayNoticeList(_ noticeList: [Notice]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Notice>()
        snapshot.appendSections([0])
        snapshot.appendItems(noticeList, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
