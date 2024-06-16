//
//  SettingsViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit

final class SettingsViewController: UIViewController, Toastable {
    private let disposeBag = DisposeBag()
    private let viewModel: DefaultSettingsViewModel
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let musicAppButtonEvent: PublishRelay<String> = .init()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SettingSection, SettingItem>?
    
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
        label.text = "설정"
        label.textColor = UIColor(red: 0.844, green: 0.881, blue: 0.933, alpha: 1)
        label.font = .pretendard(size: 16, weightName: .bold)
        label.setLineHeight(lineHeight: 20)
        return label
    }()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: DefaultSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
            self.navigationBar,
            self.collectionView
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
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionView

extension SettingsViewController: UICollectionViewDelegate {
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(52)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), 
                heightDimension: .estimated(52)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), 
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0, 
                leading: 24,
                bottom: 24,
                trailing: 24
            )
            section.interGroupSpacing = 8
            
            return section
        }
    }
    
    private func configureDataSource() {
        typealias Registration = UICollectionView.CellRegistration
        typealias MusicSelectCellRegistration = Registration<SettingMusicSelectCell, SettingItem>
        typealias PushNotiCellRegistration = Registration<SettingPushNotificationCell, SettingItem>
        typealias ElementCellRegistration = Registration<SettingElementCell, SettingItem>
        
        let musicSelectCellRegistration = MusicSelectCellRegistration { cell, indexPath, item in
            guard case .musicApp(let musicApp) = item else { return }
            cell.configure(
                with: item,
                selectedMusicApp: musicApp
            ) { [weak self] musicAppQueryString in
                self?.handleMusicAppSelected(musicAppQueryString)
            }
        }
        
        let pushNotificationCellRegistration = PushNotiCellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        
        let elementCellRegistration = ElementCellRegistration { cell, indexPath, item in
            if case let .notice(hasNewNotice) = item {
                cell.configure(with: item, showNewBadge: hasNewNotice)
            } else {
                cell.configure(with: item)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<SettingSection, SettingItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .musicApp:
                return collectionView.dequeueConfiguredReusableCell(
                    using: musicSelectCellRegistration,
                    for: indexPath,
                    item: item
                )
                
            case .pushNotifications:
                return collectionView.dequeueConfiguredReusableCell(
                    using: pushNotificationCellRegistration,
                    for: indexPath,
                    item: item
                )
                
            default:
                return collectionView.dequeueConfiguredReusableCell(
                    using: elementCellRegistration,
                    for: indexPath,
                    item: item
                )
                
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SettingHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] headerView, elementKind, indexPath in
            guard let snapshot = self?.dataSource?.snapshot(),
                  let sectionIdentifier = snapshot.sectionIdentifiers[safe: indexPath.section]
            else { return }
            
            headerView.configure(with: sectionIdentifier.title)
        }
        
        dataSource?.supplementaryViewProvider = { view, kind, index in
            self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: index
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .serviceUsageGuide, .privacyPolicy, .feedback:
            guard let urlString = item.urlAddress,
                  let url = URL(string: urlString)
            else { return }
            
            UIApplication.shared.open(url)
            
        case .notice(_):
            // TODO: jihye
//            let noticeListViewController = NoticeListViewController(viewModel: .init())
//            self.navigationController?.pushViewController(
//                noticeListViewController,
//                animated: true
//            )
            return
            
        default:
            return
        }
    }
}

extension SettingsViewController {
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
        let input = DefaultSettingsViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            musicAppButtonEvent: musicAppButtonEvent.asObservable()
        )
        
        let output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.currentMusicApp
            .bind { [weak self] musicApp in
                self?.updateSelectedMusicApp(musicApp)
            }
            .disposed(by: disposeBag)
        
        output.savedMusicAppInServer
            .bind { [weak self] savedMusicAppInServer in
                self?.updateSelectedMusicApp(savedMusicAppInServer)
                self?.showMusicAppCheckBoxToast(
                    text: "연결 앱이 변경되었어요!",
                    bottomInset: 44,
                    duration: .now() + 3
                )
            }
            .disposed(by: disposeBag)
        
        output.changingMusicAppFailAlert
            .bind { [weak self] message in
                self?.showFailNormalToast(
                    text: message,
                    bottomInset: 44,
                    duration: .now() + 3
                )
            }
            .disposed(by: disposeBag)
        
        output.defaultSettingSectionTypes
            .bind { [weak self] settingSectionTypes in
                self?.displaySettingSections(settingSectionTypes)
            }
            .disposed(by: disposeBag)
    }
    
    private func displaySettingSections(_ settingSectionTypes: [SettingSectionType]) {
        var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingItem>()
        
        settingSectionTypes.forEach { settingSectionType in
            snapshot.appendSections([settingSectionType.section])
            snapshot.appendItems(settingSectionType.items, toSection: settingSectionType.section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func handleMusicAppSelected(_ queryString: String) {
        musicAppButtonEvent.accept(queryString)
    }
    
    private func updateSelectedMusicApp(_ selectedMusicApp: MusicApp) {
        guard var snapshot = self.dataSource?.snapshot() else { return }
        
        if snapshot.sectionIdentifiers.contains(.appSettings) {
            let items = snapshot.itemIdentifiers(
                inSection: .appSettings
            ).map { item -> SettingItem in
                if case .musicApp(_) = item {
                    return .musicApp(selectedMusicApp)
                }
                return item
            }
            
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .appSettings))
            snapshot.appendItems(items, toSection: .appSettings)
        }
        
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
