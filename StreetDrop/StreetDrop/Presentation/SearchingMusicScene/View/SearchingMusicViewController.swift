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
    
    init(viewModel: DefaultSearchingMusicViewModel = DefaultSearchingMusicViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchView: UIView = {
        let uiView: UIView = UIView()
        return uiView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = UIColor(red: 0.121, green: 0.146, blue: 0.22, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(
            string: "드랍할 음악 검색",
            attributes: [
                .foregroundColor: UIColor(red: 0.235, green: 0.269, blue: 0.354, alpha: 1)
            ]
        )
        textField.textColor = UIColor(red: 0.867, green: 0.902, blue: 0.942, alpha: 1)
        textField.layer.cornerRadius = 8.0
        
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
        
        textField.rightView = self.searchCancleView
        textField.rightViewMode = .whileEditing
        return textField
    }()
    
    private lazy var searchCancleView: UIView = {
        let uiView = UIView()
        return uiView
    }()
    
    private lazy var searchCancleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancleButton"), for: .normal)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(
            SearchingMusicTableViewCell.self,
            forCellReuseIdentifier: SearchingMusicTableViewCell.identifier
        )
        tableView.rowHeight = 76
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.024, green: 0.046, blue: 0.12, alpha: 1)
        bindUI()
        bindViewModel()
        setupLayout()
    }
}

private extension SearchingMusicViewController {
    func bindUI() {
        self.searchCancleButton.rx.tap
            .bind {
                self.searchTextField.text = ""
                self.searchTextField.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
        
        self.searchTextField.rx.text
            .bind { keyword in
                if let keyword = keyword {
                    self.tableView.isHidden = keyword.isEmpty
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = DefaultSearchingMusicViewModel.Input(
            viewDidAppearEvent: .just(()),
            searchTextFieldDidEditEvent: self.searchTextField.rx.text.orEmpty
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
    }
    
    func setupLayout() {
        [
            self.backButton,
            self.searchTextField
        ].forEach {
            self.searchView.addSubview($0)
        }
        
        self.searchCancleView.addSubview(self.searchCancleButton)
        
        [
            self.searchView,
            self.tableView
        ].forEach {
            self.view.addSubview($0)
        }
        
        self.searchView.snp.makeConstraints {
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
        
        self.searchCancleView.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(44)
        }
        
        self.searchCancleButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchView.snp.bottom).offset(26)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
