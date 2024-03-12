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

final class SearchingMusicViewController: UIViewController {
    private let viewModel: DefaultSearchingMusicViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    
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
        configureGADBannerView()
    }
    
    // MARK: - UI
    
    private lazy var searchView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
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
    
    private lazy var recentMusicSearchView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private lazy var recentSearchResultLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "최근 검색어"
        label.textColor = UIColor.gray150
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 20)
        return label
    }()
    
    private lazy var recentMusicSearchScrollView: RecentMusicSearchScrollView = {
        let scrollView = RecentMusicSearchScrollView()
        return scrollView
    }()
    
    private lazy var recommendMusicSearchCollectionView: RecommendMusicSearchCollectionView = {
        let collectionView = RecommendMusicSearchCollectionView()
        return collectionView
    }()
    
    private lazy var questionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(
            SearchingMusicTableViewCell.self,
            forCellReuseIdentifier: SearchingMusicTableViewCell.identifier
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
                    self.recentMusicSearchView.isHidden = !keyword.isEmpty
                }
            }
            .disposed(by: disposeBag)
        
        self.recentMusicSearchScrollView.queryButtonDidTappedEvent
            .bind { recentQuery in
                self.searchTextField.text = recentQuery
                self.tableView.isHidden = false
                self.recentMusicSearchView.isHidden = true
                self.searchTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        self.recommendMusicSearchCollectionView.queryButtonDidTappedEvent
            .bind { recentQuery in
                self.searchTextField.text = recentQuery
                self.tableView.isHidden = false
                self.recentMusicSearchView.isHidden = true
                self.searchTextField.resignFirstResponder()
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
        
        let searchTextFieldEmptyEvent = self.searchTextField.rx.text.orEmpty.filter{
            $0.isEmpty
        }.map { _ in }
        
        let input = DefaultSearchingMusicViewModel.Input(
            viewDidAppearEvent: .just(()),
            searchTextFieldEmptyEvent: searchTextFieldEmptyEvent,
            keyBoardDidPressSearchEventWithKeyword: keyBoardDidPressSearchEventWithKeyword,
            recentQueryDidPressEvent: self.recentMusicSearchScrollView.queryButtonDidTappedEvent,
            recommendQueryDidPressEvent: self.recommendMusicSearchCollectionView.queryButtonDidTappedEvent,
            tableViewCellDidPressedEvent: selectedTableViewCellEvent
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
        
        output.recentMusicQueries
            .observe(on: MainScheduler.instance)
            .bind { queries in
                self.recentMusicSearchScrollView.setData(queries: queries)
            }
            .disposed(by: disposeBag)
        
        output.recommendMusicQueries
            .observe(on: MainScheduler.instance)
            .bind { queries in
                self.setRecommendData(queries.description)
                self.recommendMusicSearchCollectionView.setData(queries: queries.terms)
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
        
        [
            self.recentSearchResultLabel,
            self.recentMusicSearchScrollView,
            self.questionLabel,
            self.recommendMusicSearchCollectionView
        ].forEach {
            self.recentMusicSearchView.addSubview($0)
        }
        
        self.searchCancelView.addSubview(self.searchCancelButton)
        
        [
            self.searchView,
            self.tableView,
            self.recentMusicSearchView,
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
        
        self.recentMusicSearchView.snp.makeConstraints {
            $0.top.equalTo(self.searchView.snp.bottom).offset(22)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.recentSearchResultLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        self.recentMusicSearchScrollView.snp.makeConstraints {
            $0.top.equalTo(self.recentSearchResultLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(33)
        }
        
        self.questionLabel.snp.makeConstraints {
            $0.top.equalTo(self.recentMusicSearchScrollView.snp.bottom).offset(54)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.recommendMusicSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.questionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(144)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchView.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
        
        self.bannerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(50)
        }
    }
    
    func setRecommendData(_ query: [RecommendMusicData]) {
        let attributedString =  NSMutableAttributedString()
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 32
        style.minimumLineHeight = 32
        
        for data in query {
            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor: FontType(rawValue: data.color)?.foregroundColor ?? .white,
                .paragraphStyle: style
            ]
            attributedString.append(NSAttributedString(string: data.text, attributes: attributes))
        }
        questionLabel.attributedText = attributedString
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
