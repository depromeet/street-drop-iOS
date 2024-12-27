//
//  RegionFilteringModalViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class RegionFilteringModalViewController: UIViewController, ModalPresentable {
    var upperMarginHeight: CGFloat = 158
    var containerViewTopConstraint: Constraint?
    let disposeBag: DisposeBag = .init()
    private let viewModel: RegionFilteringModalViewModel = .init()
    private var cityDataSource: UITableViewDiffableDataSource<Int, String>?
    private var guDataSource: UITableViewDiffableDataSource<Int, String>?
    private let cityCellClickEvent: PublishRelay<String> = .init()
    
    let modalContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        
        return view
    }()
    
    private let regionFilterLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "지역 필터"
        label.textColor = .textPrimary
        label.font = .pretendard(size: 20, weight: 700)
        label.setLineHeight(lineHeight: 28)
        
        label.textAlignment = .center
        
        return label
    }()
    
    private let line: UIView = {
        let view: UIView = .init()
        
        return view
    }()
    
    private lazy var cityTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.backgroundColor = .gray900
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.rowHeight = 56
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var guTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.backgroundColor = .gray800
        tableView.register(GuTableViewCell.self, forCellReuseIdentifier: GuTableViewCell.identifier)
        tableView.rowHeight = 56
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let filteringButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .primary400
        button.layer.cornerRadius = 12
        button.setTitle("0개", for: .normal)
        button.setTitleColor(.gray900, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: 700)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModal()
        configureDataSource()
        bindViewModel()
        configureUI()
    }
}

private extension RegionFilteringModalViewController {
    func bindViewModel() {
        let input: RegionFilteringModalViewModel.Input = .init(
            viewDidLoadEvent: .just(Void()),
            cityCellClickEvent: cityCellClickEvent.asObservable()
        )
        
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.cityNames
            .bind(with: self) { owner, cityNames in
                owner.displayCityNames(cityNames)
            }
            .disposed(by: disposeBag)
        
        output.guNames
            .bind(with: self) { owner, guNames in
                owner.displayGuNames(guNames)
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        [
            regionFilterLabel,
            line,
            cityTableView,
            guTableView,
            filteringButton
        ].forEach {
            modalContainerView.addSubview($0)
        }
        
        regionFilterLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.horizontalEdges.equalToSuperview().inset(24)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(regionFilterLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        cityTableView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.top.equalTo(line.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(filteringButton.snp.top).offset(-12)
        }
        
        guTableView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom)
            $0.leading.equalTo(cityTableView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(cityTableView)
        }
        
        filteringButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func displayCityNames(_ cityNames: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(cityNames, toSection: 0)
        cityDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func displayGuNames(_ cityNames: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(cityNames, toSection: 0)
        guDataSource?.apply(snapshot, animatingDifferences: false) {
            DispatchQueue.main.async { [weak self] in
                if let rowCount = self?.guTableView.numberOfRows(inSection: 0), rowCount > 0 {
                    self?.guTableView.selectRow(
                        at: IndexPath(row: 0, section: 0),
                        animated: true,
                        scrollPosition: .top
                    )
                } else {
                    print("No rows available to select.")
                }
            }
        }
    }
}

// MARK: - Table View

extension RegionFilteringModalViewController: UITableViewDelegate {
    private func configureDataSource() {
        cityDataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: cityTableView,
            cellProvider: { tableView, indexPath, city -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CityTableViewCell.identifier,
                    for: indexPath
                ) as? CityTableViewCell else { return UITableViewCell() }
                cell.configure(regionName: city)
                
                return cell
            }
        )
        
        guDataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: guTableView,
            cellProvider: { tableView, indexPath, gu -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: GuTableViewCell.identifier,
                    for: indexPath
                ) as? GuTableViewCell else { return UITableViewCell() }
                cell.configure(regionName: gu)
                
                return cell
            }
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCity = cityDataSource?.itemIdentifier(for: indexPath) {
            cityCellClickEvent.accept(selectedCity)
        }
    }
}
