//
//  ReSearchingMusicForSharingView.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/16/24.
//

import UIKit

import RxSwift
import RxRelay
import SnapKit

final class ReSearchingMusicForSharingView: UIView {
    private let reSearchingEventRelay: PublishRelay<String> = .init()
    // View -> ViewController
    var reSearchingEvent: Observable<String> {
        reSearchingEventRelay.asObservable()
    }
    // ViewController -> View
    let settingMusicDataRelay: PublishRelay<[Music]> = .init()
    private let disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindData()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backbutton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(named: "backButton"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "직접 검색"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 16, weight: 700)
        label.setLineHeight(lineHeight: 24)
        
        return label
    }()
    
    private let exitButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(.init(named: "exit"), for: .normal)
        
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = UIColor.gray700
        textField.attributedPlaceholder = NSAttributedString(
            string: "드랍할 음악 검색",
            attributes: [
                .foregroundColor: UIColor.gray400
            ]
        )
        textField.textColor = .textPrimary
        textField.layer.cornerRadius = 12.0
        
        textField.returnKeyType = .search
        
        let leftPaddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: 44
            )
        )
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.rightView = searchCancelView
        textField.rightViewMode = .whileEditing
        return textField
    }()
    
    private lazy var searchCancelView: UIView = {
        let view: UIView = .init()
        
        return view
    }()
    
    private lazy var searchCancelButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(UIImage(named: "cancleButton"), for: .normal)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.backgroundColor = .clear
        tableView.register(
            ReSearchingMusicTableViewCell.self,
            forCellReuseIdentifier: ReSearchingMusicTableViewCell.identifier
        )
        tableView.rowHeight = 80
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
    }()
}

private extension ReSearchingMusicForSharingView {
    func bindData() {
        settingMusicDataRelay
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: ReSearchingMusicTableViewCell.identifier,
                    cellType: ReSearchingMusicTableViewCell.self
                )
            ) { (row, music, reSearchingMusicTableViewCell) in
                reSearchingMusicTableViewCell.setData(music: music)
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [
            backbutton,
            titleLabel,
            searchTextField,
            exitButton,
            tableView
        ].forEach {
            addSubview($0)
        }
        
        searchCancelView.addSubview(searchCancelButton)

        backbutton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(32)
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
