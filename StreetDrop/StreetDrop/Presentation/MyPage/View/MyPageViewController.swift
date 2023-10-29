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

final class MyPageViewController: UIViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<MyMusicsSection>
    
    enum TableViewType: Int {
        case dropMusic = 100
        case likeMusic = 101
    }
    
    private var stickyTapListStackView: UIStackView?
    private var stickyTopDimmedView: UIView?
    
    private lazy var dropMusicDataSource: DataSource = configureDataSource()
    private lazy var likeMusicDataSource: DataSource = configureDataSource()
    
    private var viewModel: MyPageViewModel
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearEvent.accept(Void())
    }
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.gray900
        scrollView.delegate = self
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
    
    private lazy var levelImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
    
    private lazy var tapListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .bottom
        return stackView
    }()
    
    private lazy var dropTapButton: UIButton = {
        let button = UIButton()
        button.setTitle("드랍", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        return button
    }()
    
    private lazy var likeTapButton: UIButton = {
        let button = UIButton()
        button.setTitle("좋아요", for: .normal)
        button.setTitleColor(UIColor.gray400, for: .normal)
        button.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
        button.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        return button
    }()
    
    private lazy var dropCountLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 0개"
        label.textColor = UIColor.gray400
        label.font = .pretendard(size: 14, weightName: .regular)
        return label
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 0개"
        label.textColor = UIColor.gray400
        label.font = .pretendard(size: 14, weightName: .regular)
        label.isHidden = true
        return label
    }()
    
    private lazy var dropMusicListTableView: MusicListTableView = {
        let tableView = MusicListTableView()
        tableView.backgroundColor = .gray900
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        tableView.register(MusicListSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MusicListSectionHeaderView.identifier)
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = UIView()
        tableView.tag = TableViewType.dropMusic.rawValue
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var likeMusicListTableView: MusicListTableView = {
        let tableView = MusicListTableView()
        tableView.backgroundColor = .gray900
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        tableView.register(MusicListSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MusicListSectionHeaderView.identifier)
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = UIView()
        tableView.tag = TableViewType.likeMusic.rawValue
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
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
        
        // MARK: - Level ImageView
        
        self.containerView.addSubview(levelImageView)
        self.levelImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.width.equalTo(243)
            make.height.equalTo(184)
        }
        
        // MARK: - Level Tag Container View
        
        self.containerView.addSubview(levelTagContainerView)
        self.levelTagContainerView.snp.makeConstraints { make in
            make.top.equalTo(levelImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        
        // MARK: - Level Tag Label
        
        self.levelTagContainerView.addSubview(levelTagLabel)
        self.levelTagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(12)
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
        
        // MARK: - Tap List StackView
        
        self.containerView.addSubview(tapListStackView)
        self.tapListStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Drop Tap Button
        
        self.tapListStackView.addArrangedSubview(dropTapButton)
        
        // MARK: - Like Tap Button
        
        self.tapListStackView.addArrangedSubview(likeTapButton)
        
        // MARK: - Count Label
        
        self.tapListStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                return spacerView
            }()
        )
        
        self.tapListStackView.addArrangedSubview(dropCountLabel)
        
        // MARK: - Drop Music List TableView
        
        self.containerView.addSubview(dropMusicListTableView)
        self.dropMusicListTableView.snp.makeConstraints { make in
            make.top.equalTo(tapListStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // MARK: - Like Music List TableView
        
        self.containerView.addSubview(likeMusicListTableView)
        self.likeMusicListTableView.snp.makeConstraints { make in
            make.top.equalTo(tapListStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
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
    
    func createTapListStackView() -> UIStackView {
        let newStackView = UIStackView()
        newStackView.axis = .horizontal
        newStackView.spacing = 8
        newStackView.alignment = .bottom
        newStackView.backgroundColor = UIColor.gray900
        
        let newDropButton = UIButton()
        newDropButton.setTitle("드랍", for: .normal)
        newDropButton.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        
        let newLikeButton = UIButton()
        newLikeButton.setTitle("좋아요", for: .normal)
        newLikeButton.titleLabel?.font = .pretendard(size: 20, weightName: .bold)
        
        if self.dropMusicListTableView.isHidden {
            newDropButton.setTitleColor(UIColor.gray400, for: .normal)
            newDropButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            
            newLikeButton.setTitleColor(.white, for: .normal)
            newLikeButton.setTitleColor(.lightGray, for: .highlighted)
        } else {
            newDropButton.setTitleColor(.white, for: .normal)
            newDropButton.setTitleColor(.lightGray, for: .highlighted)
            
            newLikeButton.setTitleColor(UIColor.gray400, for: .normal)
            newLikeButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
        }
        
        let newLabel = UILabel()
        newLabel.textColor = UIColor.gray400
        newLabel.font = .pretendard(size: 14, weightName: .regular)
        if self.dropMusicListTableView.isHidden {
            newLabel.text = likeCountLabel.text
        } else {
            newLabel.text = dropCountLabel.text
        }
        
        newStackView.addArrangedSubview(newDropButton)
        newStackView.addArrangedSubview(newLikeButton)
        newStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                return spacerView
            }()
        )
        newStackView.addArrangedSubview(newLabel)
        
        bindTapButtonAction(dropTapButton: newDropButton, likeTapButton: newLikeButton)
        
        return newStackView
    }
    
    // MARK: - Action Binding
    
    private func bindTapButtonAction(dropTapButton: UIButton, likeTapButton: UIButton) {
        dropTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dropMusicListTableView.isHidden = false
                self.likeMusicListTableView.isHidden = true
                
                self.tapListStackView.removeArrangedSubview(self.likeCountLabel)
                self.likeCountLabel.isHidden = true
                self.tapListStackView.addArrangedSubview(self.dropCountLabel)
                self.dropCountLabel.isHidden = false
                
                dropTapButton.setTitleColor(.white, for: .normal)
                dropTapButton.setTitleColor(.lightGray, for: .highlighted)
                self.dropTapButton.setTitleColor(.white, for: .normal)
                self.dropTapButton.setTitleColor(.lightGray, for: .highlighted)
                likeTapButton.setTitleColor(UIColor.gray400, for: .normal)
                likeTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
                self.likeTapButton.setTitleColor(UIColor.gray400, for: .normal)
                self.likeTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
                
                if self.scrollView.contentOffset.y > 343 {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 343), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        likeTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.dropMusicListTableView.isHidden = true
                self.likeMusicListTableView.isHidden = false
                
                self.tapListStackView.removeArrangedSubview(self.dropCountLabel)
                self.dropCountLabel.isHidden = true
                self.tapListStackView.addArrangedSubview(self.likeCountLabel)
                self.likeCountLabel.isHidden = false
                
                dropTapButton.setTitleColor(UIColor.gray400, for: .normal)
                dropTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
                self.dropTapButton.setTitleColor(UIColor.gray400, for: .normal)
                self.dropTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
                likeTapButton.setTitleColor(.white, for: .normal)
                likeTapButton.setTitleColor(.lightGray, for: .highlighted)
                self.likeTapButton.setTitleColor(.white, for: .normal)
                self.likeTapButton.setTitleColor(.lightGray, for: .highlighted)
                
                if self.scrollView.contentOffset.y > 343 {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 343), animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        bindTapButtonAction(dropTapButton: self.dropTapButton, likeTapButton: self.likeTapButton)
        
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
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(
            viewWillAppearEvent: self.viewWillAppearEvent
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
        
        output.myDropMusicsSections
            .bind(to: dropMusicListTableView.rx.items(dataSource: dropMusicDataSource))
            .disposed(by: disposeBag)
        
        output.myLikeMusicsSections
            .bind(to: likeMusicListTableView.rx.items(dataSource: likeMusicDataSource))
            .disposed(by: disposeBag)
        
        output.totalDropMusicsCount
            .bind(onNext: { [weak self] count in
                self?.dropCountLabel.text = "전체 \(count)개"
            })
            .disposed(by: disposeBag)
        
        output.totalLikeMusicsCount
            .bind(onNext: { [weak self] count in
                self?.likeCountLabel.text = "전체 \(count)개"
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ScrollView Delegate

extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 맨 위로 스크롤하기 버튼 활성화
        if scrollView == self.scrollView {
            let offsetY = scrollView.contentOffset.y
            if offsetY > 400 {
                scrollToTopButton.isHidden = false
            } else {
                scrollToTopButton.isHidden = true
            }
        }
        
        // 드랍, 좋아요 탭 상단에 고정시키기
        if scrollView.contentOffset.y > 343 {
            if self.stickyTapListStackView == nil {
                self.stickyTapListStackView = createTapListStackView()
                self.stickyTopDimmedView = createDimmedView(isFromTop: true)
                
                guard let stickyTapListStackView = stickyTapListStackView else { return }
                guard let stickyDimmedView = stickyTopDimmedView else { return }
                
                self.view.addSubview(stickyTapListStackView)
                stickyTapListStackView.snp.makeConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(24)
                }
                
                self.view.addSubview(stickyDimmedView)
                stickyDimmedView.snp.makeConstraints { make in
                    make.top.equalTo(stickyTapListStackView.snp.bottom)
                    make.height.equalTo(24)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                }
            }
        } else {
            if let stickyTapListStackView = self.stickyTapListStackView,
               let stickyDimmedView = self.stickyTopDimmedView {
                stickyTapListStackView.removeFromSuperview()
                stickyDimmedView.removeFromSuperview()
            }
            self.stickyTapListStackView = nil
            self.stickyTopDimmedView = nil
        }
    }
}

// MARK: - TableView Delegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let type = TableViewType(rawValue: tableView.tag) {
            return configureHeaderView(
                type: type,
                tableView: tableView,
                section: section
            )
        } else {
            return nil
        }
    }
}

// MARK: - Private Methods

private extension MyPageViewController {
    func configureDataSource() -> DataSource {
        return DataSource(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell else { return UITableViewCell() }
                cell.setData(item: item)
                return cell
            })
    }
    
    func configureHeaderView(
        type: TableViewType,
        tableView: UITableView,
        section: Int
    ) -> UIView? {
        var dataSource: DataSource
        
        switch type {
        case .dropMusic:
            dataSource = dropMusicDataSource
        case .likeMusic:
            dataSource = likeMusicDataSource
        }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MusicListSectionHeaderView.identifier) as? MusicListSectionHeaderView
        else { return UIView() }
        
        let sectionData = dataSource[section]
        headerView.setData(date: sectionData.date)
        return headerView
    }
}

// MARK: - 커스텀 테이블뷰

private final class MusicListTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


//MARK: - for canvas
import SwiftUI
struct MyPageViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyPageViewController
    
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct MyPageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MyPageViewControllerRepresentable()
    }
}
