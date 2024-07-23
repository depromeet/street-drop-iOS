//
//  MyPageViewController.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/30.
//

import UIKit

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import SnapKit

final class MyPageViewController: UIViewController, Toastable, Alertable {
    fileprivate typealias MusicDataSource = UITableViewDiffableDataSource<MyMusicsSection, MyMusic>
    
    private var stickyTapBarView: UIView?
    private var stickyTopDimmedView: UIView?
    
    private lazy var musicDataSource: MusicDataSource = configureMusicDataSource()
    
    private var viewModel: MyPageViewModel
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let listTypeTapEvent = BehaviorRelay<MyMusicType>(value: .drop)
    private let levelPolicyTapEvent = PublishRelay<Void>()
    private let selectedMusicEvent = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    private let totalMusicsCountRelay: ReplayRelay<Int> = .create(bufferSize: 1)
    private let selectedFilterType: BehaviorRelay<FilterType> = .init(value: .newest)
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel = MyPageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindAction()
        self.bindViewModel()
    }
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.gray900
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray900
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.gray100
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .pretendard(size: 16, weightName: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingButton"), for: .normal)
        return button
    }()
    
    private lazy var levelTagContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.primary500.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 14
        return view
    }()
    
    private lazy var levelTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary500
        label.font = .pretendard(size: 12, weightName: .semiBold)
        label.text = "     "
        return label
    }()
    
    private lazy var levelGuideButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "infoIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.gray200
        button.setTitle("레벨 안내", for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weightName: .medium)
        button.setInsets(intervalPadding: 4)
        
        return button
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(size: 20, weightName: .bold)
        return label
    }()
    
    private lazy var nickNameEditButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "editIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.gray300
        return button
    }()
    
    private lazy var levelImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var levelUpGuideView = LevelUpGuideView()
    
    private lazy var tapBarView: UIView = createTapBarView(with: .drop)
    
    private lazy var musicListTableView: MusicListTableView = {
        let tableView = MusicListTableView(frame: .zero, style: .grouped)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 258
        tableView.delegate = self
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        
        tableView.register(
            MusicListCell.self,
            forCellReuseIdentifier: MusicListCell.identifier
        )
        tableView.register(
            MusicListSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: MusicListSectionHeaderView.identifier
        )
        
        return tableView
    }()
    
    private lazy var scrollToTopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor.gray600
        button.setImage(UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.primary300
        button.isHidden = true
        return button
    }()
    
    private lazy var bottomDimmedView: UIView = self.createDimmedView(isFromTop: false)
}

// MARK: - UI Methods

private extension MyPageViewController {
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - ViewController
        
        self.view.backgroundColor = UIColor.gray900
        
        // MARK: - ScrollView
        
        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        // MARK: - Container View
        
        self.scrollView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // MARK: - Title Label
        
        self.containerView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        
        // MARK: - Back Button
        
        self.containerView.addSubview(backButton)
        self.backButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().inset(24)
        }
        
        // MARK: - Settings Button
        
        self.containerView.addSubview(settingsButton)
        self.settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Level Tag Container View
        
        self.containerView.addSubview(levelTagContainerView)
        self.levelTagContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        
        // MARK: - Level Tag Label
        
        self.levelTagContainerView.addSubview(levelTagLabel)
        self.levelTagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        // MARK: - Level Guide Button
        
        self.containerView
            .addSubview(levelGuideButton)
        self.levelGuideButton.snp.makeConstraints { make in
            make.top.equalTo(levelTagContainerView)
            make.leading.greaterThanOrEqualTo(levelTagContainerView.snp.trailing).offset(50)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(levelTagContainerView)
        }
        
        // MARK: - Profile StackView
        
        self.containerView.addSubview(profileStackView)
        self.profileStackView.snp.makeConstraints { make in
            make.top.equalTo(levelTagContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - NickName Label
        
        self.profileStackView.addArrangedSubview(nickNameLabel)
        
        // MARK: - NickName Edit Button
        
        self.profileStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 4).isActive = true
                return spacerView
            }()
        )
        self.profileStackView.addArrangedSubview(nickNameEditButton)
        self.nickNameEditButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        self.profileStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.backgroundColor = UIColor.clear
                return spacerView
            }()
        )
        
        // MARK: - Level ImageView
        
        self.containerView.addSubview(levelImageView)
        self.levelImageView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(217)
            make.height.equalTo(164)
        }
        
        // MARK: - LevelUp GuideView
        
        containerView.addSubview(levelUpGuideView)
        levelUpGuideView.snp.makeConstraints {
            $0.top.equalTo(levelImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(136)
        }
        
        // MARK: - Tap List StackView
        
        self.containerView.addSubview(tapBarView)
        self.tapBarView.snp.makeConstraints { make in
            make.top.equalTo(levelUpGuideView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
                
        // MARK: - Music List CollectionView
        
        containerView.addSubview(musicListTableView)
        musicListTableView.snp.makeConstraints {
            $0.top.equalTo(tapBarView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
                
        // MARK: - Scroll To Top Button
        
        self.view.addSubview(scrollToTopButton)
        self.scrollToTopButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        // MARK: - Bottom Dimmed View
        self.view.addSubview(bottomDimmedView)
        self.bottomDimmedView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(24)
        }
    }
    
    func createDimmedView(isFromTop: Bool) -> UIView {
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.gray900
        let gradientLayer = CAGradientLayer()
        
        let startColor = UIColor.gray900.cgColor
        let endColor = UIColor.black.withAlphaComponent(0).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: isFromTop ? 0 : 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: isFromTop ? 1 : 0)
        dimmedView.layer.mask = gradientLayer
        gradientLayer.frame = CGRect(origin: .zero, size: .init(width: self.view.frame.width, height: 24))
        return dimmedView
    }
    
    func createTapBarView(with type: MyMusicType) -> UIView {
        let tabBarView = UIView()
        tabBarView.backgroundColor = .gray900
        
        let tapListView: TapListView = .init()
        tapListView.updateTapListUI(by: type)
        
        let musicListFilterView: MusicListFilterView = .init()
        
        let separatorView = UIView()
        separatorView.backgroundColor = .gray600
        
        tabBarView.addSubview(tapListView)
        tapListView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        tabBarView.addSubview(musicListFilterView)
        musicListFilterView.snp.makeConstraints {
            $0.top.equalTo(tapListView.snp.bottom)
            $0.leading.trailing.bottom  .equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tabBarView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalMusicsCountRelay
            .bind(to: musicListFilterView.rx.setMusicCountText)
            .disposed(by: disposeBag)
        
        bindTapButtonAction(in: tapListView)
        bindFilterButtonAction(in: musicListFilterView)
        
        return tabBarView
    }
    
    func updateLevelupGuideViewConstraints(by isShow: Bool) {
        if isShow == false {
            if levelUpGuideView.isDescendant(of: view) {
                levelUpGuideView.removeFromSuperview()
                
                tapBarView.snp.remakeConstraints { make in
                    make.top.equalTo(levelImageView.snp.bottom).offset(24)
                    make.leading.trailing.equalToSuperview()
                }
            }
        }
    }
    
    func updateScrollOffset() {
        if scrollView.contentOffset.y > 343 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 343), animated: true)
        }
    }
}

// MARK: - Binding Methods

private extension MyPageViewController {
    func bindTapButtonAction(in tapListView: TapListView) {
        tapListView.rx.onDropTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.listTypeTapEvent.accept(.drop)
                owner.updateScrollOffset()
            }
            .disposed(by: disposeBag)
        
        tapListView.rx.onLikeTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.listTypeTapEvent.accept(.like)
                owner.updateScrollOffset()
            }
            .disposed(by: disposeBag)
        
        listTypeTapEvent
            .bind { type in
                tapListView.updateTapListUI(by: type)
            }
            .disposed(by: disposeBag)
    }
    
    func bindFilterButtonAction(in musicListFilterView: MusicListFilterView) {
        musicListFilterView.rx.onSortFilterTap
            .withLatestFrom(selectedFilterType)
            .bind(with: self) { owner, type in
                owner.showFilteringOptionsModal(with: type)
            }
            .disposed(by: disposeBag)
        
        musicListFilterView.rx.onRegionFilterTap
            .bind(with: self) { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
        selectedFilterType
            .bind(to: musicListFilterView.rx.setSortButtonText)
            .disposed(by: disposeBag)
    }
    
    func bindAction() {
        rx.viewWillAppear
            .mapVoid()
            .bind(to: viewWillAppearEvent)
            .disposed(by: disposeBag)
        
        scrollToTopButton.rx.tap
            .bind{ [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .disposed(by: disposeBag)
        
        nickNameEditButton.rx.tap
            .bind{ [weak self] in
                self?.navigationController?.pushViewController(NicknameEditViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap
            .bind { [weak self] in
                let settingViewController = SettingsViewController(viewModel: .init())
                self?.navigationController?.pushViewController(
                    settingViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind{ [weak self] nickname in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        levelGuideButton.rx.tap
            .bind(to: levelPolicyTapEvent)
            .disposed(by: disposeBag)
        
        musicListTableView.rx.itemSelected
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                guard let item = owner.musicDataSource.itemIdentifier(for: indexPath) else { return }
                owner.selectedMusicEvent.accept(item.id)
            }
            .disposed(by: disposeBag)
        
        typealias ScrollViewState = (contentOffset: CGPoint, type: MyMusicType)
        
        scrollView.rx.contentOffset
            .withLatestFrom(listTypeTapEvent) {  (contentOffset: $0, type: $1) }
            .bind(with: self) { owner, state in
                owner.handleScrollEvent(contentOffset: state.contentOffset, type: state.type)
            }
            .disposed(by: disposeBag)
    }
        
    func bindViewModel() {
        let input = MyPageViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            listTypeTapEvent: listTypeTapEvent.asObservable(),
            levelPolicyTapEvent: levelPolicyTapEvent.asObservable(),
            selectedMusicEvent: selectedMusicEvent.asObservable()
        )
        
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.levelName
            .bind(onNext: { [weak self] levelName in
                self?.levelTagLabel.text = levelName
            })
            .disposed(by: disposeBag)
        
        output.nickName
            .bind(onNext: { [weak self] nickName in
                self?.nickNameLabel.text = nickName
            })
            .disposed(by: disposeBag)
        
        output.levelImageURL
            .bind(onNext: { [weak self] levelImageURL in
                guard let self = self else { return }
                self.levelImageView.setImage(with: levelImageURL)
            })
            .disposed(by: disposeBag)
        
        output.myMusicsSections
            .bind(with: self) { owner, sections in
                owner.displayMusicList(sections)
            }
            .disposed(by: disposeBag)
        
        output.totalMusicsCount
            .bind(to: totalMusicsCountRelay)
            .disposed(by: disposeBag)
        
        output.pushCommunityView
            .bind(with: self) { owner, musics in
                let communityViewModel = CommunityViewModel(
                    communityInfos: musics,
                    index: 0
                )
                
                let communityViewController = CommunityViewController(viewModel: communityViewModel)
                
                self.navigationController?.pushViewController(
                    communityViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        output.toast
            .bind(with: self) { owner, message in
                owner.showFailNormalToast(
                    text: message,
                    bottomInset: 44,
                    duration: .now() + 3
                )
            }
            .disposed(by: disposeBag)
        
        output.isShowingLevelUpView
            .bind(with: self) { owner, isShow in
                owner.updateLevelupGuideViewConstraints(by: isShow)
            }
            .disposed(by: disposeBag)
        
        output.remainCountToLevelUp
            .bind(to: levelUpGuideView.rx.setRemainDropGuideText)
            .disposed(by: disposeBag)
        
        output.currentDropStateCount
            .bind(to: levelUpGuideView.rx.setCurrentDropStateText)
            .disposed(by: disposeBag)
        
        output.currentDropStateCount
            .bind(to: levelUpGuideView.rx.setProgress)
            .disposed(by: disposeBag)
        
        output.tipText
            .bind(to: levelUpGuideView.rx.setTipText)
            .disposed(by: disposeBag)
        
        output.levelPolicies
            .bind(with: self) { owner, levelPolicies in
                owner.showLevelPolicy(levelPolicies)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ScrollView Methods

private extension MyPageViewController {
    func handleScrollEvent(contentOffset: CGPoint, type: MyMusicType) {
        // 맨 위로 스크롤하기 버튼 활성화
        let offsetY = contentOffset.y
        if offsetY > 400 {
            scrollToTopButton.isHidden = false
        } else {
            scrollToTopButton.isHidden = true
        }
        
        // 드랍, 좋아요 탭 상단에 고정시키기
        if contentOffset.y > 343 {
            if self.stickyTapBarView == nil {
                self.stickyTapBarView = createTapBarView(with: type)
                self.stickyTopDimmedView = createDimmedView(isFromTop: true)
                
                guard let stickyTapBarView,
                      let stickyDimmedView = stickyTopDimmedView
                else { return }
                
                self.view.addSubview(stickyTapBarView)
                stickyTapBarView.snp.makeConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                }
                
                self.view.addSubview(stickyDimmedView)
                stickyDimmedView.snp.makeConstraints { make in
                    make.top.equalTo(stickyTapBarView.snp.bottom)
                    make.height.equalTo(24)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                }
            }
        } else {
            if let stickyTapBarView,
               let stickyDimmedView = self.stickyTopDimmedView {
                stickyTapBarView.removeFromSuperview()
                stickyDimmedView.removeFromSuperview()
            }
            self.stickyTapBarView = nil
            self.stickyTopDimmedView = nil
        }
    }
}

// MARK: - Private Methods

private extension MyPageViewController {
    func configureMusicDataSource() -> MusicDataSource {
        return MusicDataSource(tableView: musicListTableView, cellProvider:  { tableView, indexPath, item -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MusicListCell.identifier,
                for: indexPath
            ) as? MusicListCell else { return nil }
            
            cell.setData(item: item)
            
            return cell
        })
    }
    
    func displayMusicList(_ sectionTypes: [MyMusicsSectionType]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyMusicsSection, MyMusic>()
        
        sectionTypes.forEach { sectionType in
            snapshot.appendSections([sectionType.section])
            snapshot.appendItems(sectionType.items, toSection: sectionType.section)
        }
        
        musicDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func showFilteringOptionsModal(with selectedType: FilterType) {
        let newestOption = ModalOption(
            icon: UIImage(named: "icon-selected"),
            title: FilterType.newest.title,
            acton: filterMusicList(by: .newest),
            isSelected: selectedType == .newest
        )
        
        let oldestOption = ModalOption(
            icon: UIImage(named: "icon-selected"),
            title: FilterType.oldest.title,
            acton: filterMusicList(by: .oldest),
            isSelected: selectedType == .oldest
        )
        
        let mostPopularOption = ModalOption(
            icon: UIImage(named: "icon-selected"),
            title: FilterType.mostPopular.title,
            acton: filterMusicList(by: .mostPopular),
            isSelected: selectedType == .mostPopular
        )
        
        let modalView = OptionModalViewController(
            type: .filterMusicList,
            firstOption: newestOption,
            secondOption: oldestOption,
            thirdOption: mostPopularOption
        )
        
        modalView.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(modalView, animated: true)
    }
    
    func filterMusicList(by type: FilterType) -> UIAction {
        return UIAction { [weak self] _ in
            self?.selectedFilterType.accept(type)
            self?.navigationController?.dismiss(animated: true)
            
            /*
             TODO:
             - API 개발후 작업 예정
             */
        }
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.musicDataSource.snapshot().sectionIdentifiers[safe: section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MusicListSectionHeaderView.identifier) as? MusicListSectionHeaderView
        
        if case let .musics(date) = section {
            headerView?.setData(date: date)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
