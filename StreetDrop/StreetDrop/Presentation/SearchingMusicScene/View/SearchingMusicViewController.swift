//
//  SearchingMusicViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/05/19.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import GoogleMobileAds

struct RecommendMusicSectionModel {
    let type: SectionType
    let items: [Item]
    
    enum SectionType: Hashable {
        case recentSearchKeyword
        case trendingMusic
        case mostDroppedMusic
        case artist
        
        var title: String {
            switch self {
            case .recentSearchKeyword:
                return "최근 검색어"
            case .trendingMusic:
                return "지금 인기 있는 음악"
            case .mostDroppedMusic:
                return "많이 드랍된 음악"
            case .artist:
                return "아티스트"
            }
        }
        
        var infoText: String? {
            switch self {
            case .trendingMusic:
                return "애플 뮤직의 ‘지금 인기 있는 곡’\n리스트를 반영했어요."
            default:
                return nil
            }
        }
    }
    
    enum Item: Hashable {
        case recentSearchKeyword(String)
        case trendingMusic(Music)
        case mostDroppedMusic(Music)
        case artist(Artist)
    }
}

final class SearchingMusicViewController: UIViewController {
    typealias Section = RecommendMusicSectionModel.SectionType
    typealias Item = RecommendMusicSectionModel.Item
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let viewModel: DefaultSearchingMusicViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let deletingButtonTappedEvent = PublishRelay<String>()
    private let recentQueryDidPressEvent = PublishRelay<String>()
    private let artistQueryDidPressEvent = PublishRelay<String>()
    private let musicDidPressEvent = PublishRelay<Music>()
    
    private var collectionView: UICollectionView?
    private var dataSource: DataSource?
    
    init(viewModel: DefaultSearchingMusicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        bindAction()
        bindViewModel()
        configureUI()
        configureCollectionView()
        configureDataSource()
        configureGADBannerView()
        
        self.viewDidLoadEvent.accept(Void())
    }
    
    // MARK: - UI
    
    private lazy var searchView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = .pretendard(size: 14, weightName: .medium)
        textField.backgroundColor = UIColor.gray700
        textField.attributedPlaceholder = NSAttributedString(
            string: "드랍할 음악 검색",
            attributes: [
                .foregroundColor: UIColor.gray300
            ]
        )
        textField.textColor = UIColor.gray100
        textField.layer.cornerRadius = 8.0
        
        textField.returnKeyType = .search
        
        let leftPaddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: 56
            )
        )
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.rightView = self.searchCancelView
        textField.rightViewMode = .whileEditing
        return textField
    }()
    
    private lazy var searchCancelView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var searchCancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancleButton"), for: .normal)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        return button
    }()
    
    // TODO: jihye -> RecommendMusicListViewController
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(
            SearchingMusicTableViewCell.self,
            forCellReuseIdentifier: SearchingMusicTableViewCell.identifier
        )
        tableView.contentInset = UIEdgeInsets(
            top: 8, left: 0, bottom: 32, right: 0
        )
        tableView.rowHeight = 76
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private var bannerView: GADBannerView = {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        return bannerView
    }()
}

extension SearchingMusicViewController {
    private func displayList(
        queryItems: [Item],
        trendingItems: [Item],
        droppedItems: [Item],
        artistItems: [Item]
    ) {
        var snapshot = Snapshot()
        
        if !queryItems.isEmpty {
            snapshot.appendSections([Section.recentSearchKeyword])
            snapshot.appendItems(queryItems, toSection: .recentSearchKeyword)
        }
        
        if !trendingItems.isEmpty {
            snapshot.appendSections([Section.trendingMusic])
            snapshot.appendItems(trendingItems, toSection: .trendingMusic)
        }
        
        if !droppedItems.isEmpty {
            snapshot.appendSections([Section.mostDroppedMusic])
            snapshot.appendItems(droppedItems, toSection: .mostDroppedMusic)
        }
        
        if !artistItems.isEmpty {
            snapshot.appendSections([Section.artist])
            snapshot.appendItems(artistItems, toSection: .artist)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: CollectionView

extension SearchingMusicViewController: UICollectionViewDelegate {
    private func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(
            top: 16, left: 0, bottom: 0, right: 0
        )
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.bannerView.snp.top)
        }
        
        self.collectionView = collectionView
    }
    
    private func configureDataSource() {
        typealias CellRegistration = UICollectionView.CellRegistration
        typealias RecentSearchCellRegistration = CellRegistration<RecentQueryCell, String>
        typealias MusicCellRegistration = CellRegistration<RecommendMusicCell, Music>
        typealias ArtistCellRegistration = CellRegistration<RecommendArtistCell, Artist>
        
        guard let collectionView else { return }
        
        let recentSearchCellRegistration = RecentSearchCellRegistration { [weak self] cell, indexPath, item in
            guard let self else { return }
            cell.configure(with: item, deletingButtonTappedEvent: self.deletingButtonTappedEvent)
        }
        
        let musicCellRegistration = MusicCellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        
        let artistCellRegistration = ArtistCellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        
        collectionView.register(
            RecentSearchesHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecentSearchesHeaderView.reuseIdentifier
        )
        
        collectionView.register(
            RecommendHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, 
            withReuseIdentifier: RecommendHeaderView.reuseIdentifier
        )
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            
            switch item {
            case .recentSearchKeyword(let keyword):
                return collectionView.dequeueConfiguredReusableCell(
                    using: recentSearchCellRegistration,
                    for: indexPath,
                    item: keyword
                )
                
            case .trendingMusic(let music):
                return collectionView.dequeueConfiguredReusableCell(
                    using: musicCellRegistration,
                    for: indexPath,
                    item: music
                )
                
            case .mostDroppedMusic(let music):
                return collectionView.dequeueConfiguredReusableCell(
                    using: musicCellRegistration,
                    for: indexPath,
                    item: music
                )
                
            case .artist(let artist):
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let dataSource = self?.dataSource,
                  let section = dataSource.snapshot().sectionIdentifiers[safe: indexPath.section]
            else { return nil }
            
            switch section {
            case .recentSearchKeyword:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecentSearchesHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? RecentSearchesHeaderView
                headerView?.configure(with: section.title)
                
                return headerView
                
            case .trendingMusic:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecommendHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? RecommendHeaderView
                headerView?.configure(
                    with: section.title,
                    infoText: section.infoText
                ) { [weak self] in
                    guard let self else { return }
                    self.routeToMusicList(
                        title: section.title,
                        musicList: self.viewModel.trendingMusicList
                    )
                }
                
                return headerView
                
            case .mostDroppedMusic:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecommendHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? RecommendHeaderView
                headerView?.configure(with: section.title) { [weak self] in
                    guard let self else { return }
                    self.routeToMusicList(
                        title: section.title,
                        musicList: self.viewModel.mostDroppedMusicList
                    )
                }
                
                return headerView
                
            case .artist:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecommendHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? RecommendHeaderView
                headerView?.configure(with: section.title, hideArrow: true)
                
                return headerView
            }
        }
    }
    
    private func routeToMusicList(title: String, musicList: [Music]) {
        let viewController = RecommendMusicListViewController(
            viewModel: DefaultRecommendMusicListViewModel(
                title: title,
                musicList: musicList,
                location: self.viewModel.location,
                address: self.viewModel.address
            )
        )
        
        self.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .recentSearchKeyword(let keyword):
            self.showSearchResultList(with: keyword)
            self.recentQueryDidPressEvent.accept(keyword)
        case .trendingMusic(let music):
            self.musicDidPressEvent.accept(music)
        case .mostDroppedMusic(let music):
            self.musicDidPressEvent.accept(music)
        case .artist(let artist):
            self.showSearchResultList(with: artist.name)
            self.artistQueryDidPressEvent.accept(artist.name)
        }
    }
    
    private func showSearchResultList(with query: String) {
        self.searchTextField.text = query
        self.tableView.isHidden = false
        self.collectionView?.isHidden = true
        self.searchTextField.resignFirstResponder()
    }
}

// MARK: - CollectionView Layout

extension SearchingMusicViewController {
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self,
                  let dataSource = self.dataSource,
                  let section = dataSource.snapshot().sectionIdentifiers[safe: sectionIndex]
            else { return nil }
            
            // TODO: jihye - bottom inset update
            if section == .recentSearchKeyword {
                return self.createRecentSearchKeywordSectionLayout()
            } else if section == .artist {
                return self.createArtistSectionLayout()
            } else {
                return self.createMusicListSectionLayout()
            }
        }
    }
    
    private func createRecentSearchKeywordSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(105),
            heightDimension: .absolute(28)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(105),
            heightDimension: .absolute(28)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8, leading: 24, bottom: 48, trailing: 24
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createArtistSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20, leading: 24, bottom: 32, trailing: 24
        )
        section.orthogonalScrollingBehavior = .none
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(28)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // trending music, mostDropped music
    private func createMusicListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .estimated(176)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitem: item, count: 3
        )
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20, leading: 24, bottom: 48, trailing: 24
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(28)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

private extension SearchingMusicViewController {
    
    // MARK: - UI
    func bindAction() {
        self.searchCancelButton.rx.tap
            .bind {
                self.searchTextField.text = ""
                self.searchTextField.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
        
        self.searchTextField.rx.text
            .bind { keyword in
                if let keyword = keyword {
                    self.tableView.isHidden = keyword.isEmpty
                    self.collectionView?.isHidden = !keyword.isEmpty
                }
            }
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let keyBoardDidPressSearchEventWithKeyword = self.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .compactMap { self.searchTextField.text }
        
        let selectedTableViewCellEvent = self.tableView.rx.itemSelected.map { $0.row }
        
        let searchTextFieldEmptyEvent = self.searchTextField.rx.text.orEmpty.filter {
            $0.isEmpty
        }.map { _ in }
        
        let input = DefaultSearchingMusicViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent,
            searchTextFieldEmptyEvent: searchTextFieldEmptyEvent,
            keyBoardDidPressSearchEventWithKeyword: keyBoardDidPressSearchEventWithKeyword,
            recentQueryDidPressEvent: self.recentQueryDidPressEvent,
            artistQueryDidPressEvent: self.artistQueryDidPressEvent,
            musicDidPressEvent: self.musicDidPressEvent,
            tableViewCellDidPressedEvent: selectedTableViewCellEvent,
            deletingButtonTappedEvent: self.deletingButtonTappedEvent
        )
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.searchedMusicList
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: SearchingMusicTableViewCell.identifier,
                    cellType: SearchingMusicTableViewCell.self
                )
            ) { (row, music, searchingMusicTableViewCell) in
                searchingMusicTableViewCell.setData(music: music)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.recentMusicQueries,
            output.trendingMusicList,
            output.mostDroppedMusicList,
            output.artists
        )
        .observe(on: MainScheduler.instance)
        .bind { [weak self] recentQueries, trendingList, droppedList, artists in
            let queryItems = recentQueries.map { Item.recentSearchKeyword($0) }
            let trendingItems = trendingList.map { Item.trendingMusic($0) }
            let droppedItems = droppedList.map { Item.mostDroppedMusic($0) }
            let artistItems = artists.map { Item.artist($0) }

            self?.displayList(
                queryItems: queryItems,
                trendingItems: trendingItems,
                droppedItems: droppedItems,
                artistItems: artistItems
            )
        }
        .disposed(by: disposeBag)
        
        output.selectedMusic
            .bind { [weak self] music in
                guard let self = self else { return }
                let musicDropViewController = MusicDropViewController(
                    viewModel: MusicDropViewModel(
                        droppingInfo: DroppingInfo(
                            location: .init(
                                latitude: self.viewModel.location.coordinate.latitude,
                                longitude: self.viewModel.location.coordinate.longitude,
                                address: self.viewModel.address
                            ),
                            music: music
                        )
                    )
                )
                
                self.navigationController?.pushViewController(
                    musicDropViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [
            self.backButton,
            self.searchTextField
        ].forEach {
            self.searchView.addSubview($0)
        }
        
        self.searchCancelView.addSubview(self.searchCancelButton)
        
        [
            self.searchView,
            self.tableView,
            self.bannerView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.searchView.snp.makeConstraints {
            // TODO: 56 -> 60으로 바꼈는지 추후에 피그마 확인
            $0.height.equalTo(56)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(bannerView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        self.backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        self.searchTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.backButton.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        self.searchCancelView.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(44)
        }
        
        self.searchCancelButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bannerView.snp.top)
        }
        
        self.bannerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(50)
        }
    }
    
    func configureGADBannerView() {
        bannerView.adUnitID = GADUnitID.searchMusic
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
}

// MARK: - TextField

extension SearchingMusicViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureSearchBarPlaceholder(with prompt: String) {
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: prompt,
            attributes: [
                .foregroundColor: UIColor.gray300
            ]
        )
    }
}

// MARK: - GADBannerViewDelegate

extension SearchingMusicViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

enum FontType: String, CaseIterable {
    case recommendTitleBasic = "RecommendTitleBasic"
    case recommendTitleHighlight = "RecommendTitleHighLight"
    case recommendKeywordBasic = "RecommendKeywordBasic"
    case recommendKeywordHighlight = "RecommendKeywordHighlight"
    
    var foregroundColor: UIColor {
        switch self {
        case .recommendTitleBasic:
            return UIColor.white
        case .recommendTitleHighlight:
            return UIColor.primary400
        case .recommendKeywordBasic:
            return UIColor.gray50.withAlphaComponent(12)
        case .recommendKeywordHighlight:
            return UIColor.gray700
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .recommendKeywordBasic:
            return UIColor.gray50.withAlphaComponent(12)
        case .recommendKeywordHighlight:
            return UIColor.gray700
        default:
            return UIColor.clear
        }
    }
}
