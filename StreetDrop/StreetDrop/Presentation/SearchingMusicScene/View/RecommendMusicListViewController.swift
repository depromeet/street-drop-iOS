//
//  RecommendMusicListViewController.swift
//  StreetDrop
//
//  Created by jihye kim on 15/08/2024.
//

import UIKit

import RxSwift
import SnapKit

final class RecommendMusicListViewController: UIViewController {
    private let viewModel: DefaultRecommendMusicListViewModel
    private let disposeBag = DisposeBag()
    
    private var dataSource: UITableViewDiffableDataSource<Int, Music>?
    
    private lazy var navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = self.viewModel.title
        label.textColor = .gray100
        label.font = .pretendard(size: 16, weightName: .bold)
        label.setLineHeight(lineHeight: 24)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.register(
            SearchingMusicTableViewCell.self,
            forCellReuseIdentifier: SearchingMusicTableViewCell.identifier
        )
        tableView.contentInset = UIEdgeInsets(
            top: 16, left: 0, bottom: 32, right: 0
        )
        tableView.rowHeight = 76
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
    }()
    
    init(
        viewModel: DefaultRecommendMusicListViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bindViewModel()
        configureUI()
        configureDataSource()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black
        
        [
            self.backButton,
            self.navigationTitleLabel
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
        
        self.navigationTitleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func bindAction() {
        Observable.merge(
            self.backButton.rx.tap.asObservable()
        )
        .bind { _ in
            self.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let musicDidPressEvent = self.tableView.rx.itemSelected.map { $0.row }
        
        let input = DefaultRecommendMusicListViewModel.Input(
            musicDidPressEvent: musicDidPressEvent
        )
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.selectedMusic
            .bind { [weak self] music in
                guard let self else { return }
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
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Music>(
            tableView: tableView
        ) { tableView, indexPath, music in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchingMusicTableViewCell.identifier,
                for: indexPath
            ) as? SearchingMusicTableViewCell
            cell?.setData(music: music)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Music>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.viewModel.musicList)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
