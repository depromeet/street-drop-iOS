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
    
    private lazy var questionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 20, weight: 700)
        label.text = "지금 이 주변에\n드랍하고 싶은 음악은 무엇인가요?"
        label.textColor = .white
        label.numberOfLines = 2
        /*
         중간 글자에 대해 attributedString을 적용하기에,
         setLineHeight(내부에서 attributedString 사용)을 쓰지 않고 직점 구현
         */
        let fullText = label.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "드랍하고 싶은 음악")
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.primary400,
            range: range
        )
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 32
        style.minimumLineHeight = 32
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (32 - label.font.lineHeight) / 4
        ]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, fullText.count - 1))
        
        label.attributedText = attributedString

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
            self.questionLabel
        ].forEach {
            self.recentMusicSearchView.addSubview($0)
        }
        
        self.searchCancelView.addSubview(self.searchCancelButton)
        
        [
            self.searchView,
            self.tableView,
            self.recentMusicSearchView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.searchView.snp.makeConstraints {
            // TODO: 56 -> 60으로 바꼈는지 추후에 피그마 확인
            $0.height.equalTo(56)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
            $0.top.equalTo(self.recentMusicSearchScrollView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchView.snp.bottom).offset(26)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - TextField
extension SearchingMusicViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
