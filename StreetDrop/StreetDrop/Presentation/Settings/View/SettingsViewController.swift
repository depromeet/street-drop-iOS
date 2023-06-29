//
//  SettingsViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SettingsViewController: UIViewController {
    private let viewModel: DefaultSettingsViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DefaultSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        label.font = .pretendard(size: 14, weight: 500)
        label.setLineHeight(lineHeight: 20)
        return label
    }()
    
    private lazy var cancleButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.textColor = UIColor(red: 0.844, green: 0.881, blue: 0.933, alpha: 1)
        button.setTitleColor(UIColor(red: 0.844, green: 0.881, blue: 0.933, alpha: 0.5), for: .highlighted)
        button.titleLabel?.font = .pretendard(size: 14, weight: 500)
        button.titleLabel?.setLineHeight(lineHeight: 20)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            InfoTableViewCell.self,
            forCellReuseIdentifier: InfoTableViewCell.identifier
        )
        tableView.backgroundColor = .clear
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindAction()
        bindViewModel()
        configureUI()
    }
}

private extension SettingsViewController {
    func bindUI() {
        let infos = SettingsInfo.allCases
        Observable.of(infos).bind(
            to: self.tableView.rx.items(
                cellIdentifier: InfoTableViewCell.identifier,
                cellType: InfoTableViewCell.self
            )
        ) { (row, info, infoTableViewCell) in
            infoTableViewCell.setData(text: info.rawValue)
        }
        .disposed(by: disposeBag)
    }
    
    func bindAction() {
        self.tableView.rx.itemSelected
            .bind { indexPath in
                guard let url = URL(string: SettingsInfo.allCases[indexPath.row].urlAddress) else {
                    return
                }
                
                UIApplication.shared.open(url)
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            self.backButton.rx.tap.asObservable(),
            self.cancleButton.rx.tap.asObservable()
        )
        .bind { _ in
            self.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = DefaultSettingsViewModel.Input()
        
        let _ = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor.gray900
        
        [
            self.backButton,
            self.navigationTitle,
            self.cancleButton
        ].forEach {
            self.navigationBar.addSubview($0)
        }
        
        [
            self.navigationBar,
            self.tableView
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
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.backButton.snp.trailing).offset(18.67)
        }
        
        self.cancleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
