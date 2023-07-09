//
//  MyPageViewController.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/06/30.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

final class MyPageViewController: UIViewController {
    private var stickyTapListStackView: UIStackView?
    private var stickyDimmedView: UIView?
    
    private let disposeBag = DisposeBag()
    
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
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray900
        return view
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
        imageView.backgroundColor = .yellow
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
        label.text = "L.3 ~~드랍퍼"
        label.textColor = UIColor.primary500
        label.font = .pretendard(size: 12, weightName: .semiBold)
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
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .white
        label.font = .pretendard(size: 20, weightName: .bold)
        return label
    }()
    
    private lazy var nickNameChangeButton: UIButton = {
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
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 0개"
        label.textColor = UIColor.gray400
        label.font = .pretendard(size: 14, weightName: .regular)
        return label
    }()
    
    private lazy var dropMusicListTableView: MusicListTableView = {
        let tableView = MusicListTableView()
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var likeMusicListTableView: MusicListTableView = {
        let tableView = MusicListTableView()
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.identifier)
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
        
        // MARK: - Settings Button
        
        self.containerView.addSubview(settingsButton)
        self.settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Level ImageView
        
        self.containerView.addSubview(levelImageView)
        self.levelImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(169)
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
        
        // MARK: - Profile ImageView
        
        self.profileStackView.addArrangedSubview(profileImageView)
        self.profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        // MARK: - NickName Label
        
        self.profileStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 8).isActive = true
                return spacerView
            }()
        )
        self.profileStackView.addArrangedSubview(nickNameLabel)
        
        // MARK: - NickName Change Button
        
        self.profileStackView.addArrangedSubview(
            {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.backgroundColor = UIColor.clear
                spacerView.widthAnchor.constraint(equalToConstant: 4).isActive = true
                return spacerView
            }()
        )
        self.profileStackView.addArrangedSubview(nickNameChangeButton)
        self.nickNameChangeButton.snp.makeConstraints { make in
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
        
        self.tapListStackView.addArrangedSubview(countLabel)
        
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
    }
    
    // MARK: - Action Binding
    
    private func bindAction() {
        dropTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dropMusicListTableView.isHidden = false
                self?.likeMusicListTableView.isHidden = true
                
                self?.dropTapButton.setTitleColor(.white, for: .normal)
                self?.dropTapButton.setTitleColor(.lightGray, for: .highlighted)
                self?.likeTapButton.setTitleColor(UIColor.gray400, for: .normal)
                self?.likeTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
            })
            .disposed(by: disposeBag)
        
        likeTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dropMusicListTableView.isHidden = true
                self?.likeMusicListTableView.isHidden = false
                
                self?.dropTapButton.setTitleColor(UIColor.gray400, for: .normal)
                self?.dropTapButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
                self?.likeTapButton.setTitleColor(.white, for: .normal)
                self?.likeTapButton.setTitleColor(.lightGray, for: .highlighted)
            })
            .disposed(by: disposeBag)
        
        scrollToTopButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        // TODO: - 목데이터 대신 뷰모델 연결 필요
        Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .bind(to: dropMusicListTableView.rx.items(cellIdentifier: MusicTableViewCell.identifier, cellType: MusicTableViewCell.self)) { index, item, cell in
                // 뷰모델 연결 필요
            }
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .bind(to: likeMusicListTableView.rx.items(cellIdentifier: MusicTableViewCell.identifier, cellType: MusicTableViewCell.self)) { index, item, cell in
                // 뷰모델 연결 필요
            }
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
                self.stickyDimmedView = createDimmedView()
                
                guard let stickyTapListStackView = stickyTapListStackView else { return }
                guard let stickyDimmedView = stickyDimmedView else { return }
                
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
               let stickyDimmedView = self.stickyDimmedView {
                stickyTapListStackView.removeFromSuperview()
                stickyDimmedView.removeFromSuperview()
            }
            self.stickyTapListStackView = nil
            self.stickyDimmedView = nil
        }
    }
    
    private func createDimmedView() -> UIView {
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.gray900
        let gradientLayer = CAGradientLayer()

        let startColor = UIColor.gray900.cgColor
        let endColor = UIColor.black.withAlphaComponent(0).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        dimmedView.layer.mask = gradientLayer
        gradientLayer.frame = CGRect(origin: .zero, size: .init(width: self.view.frame.width, height: 24))
        return dimmedView
    }
    
    private func createTapListStackView() -> UIStackView {
        let newStackView = UIStackView()
        newStackView.axis = .horizontal
        newStackView.spacing = 8
        newStackView.alignment = .bottom
        newStackView.backgroundColor = UIColor.gray900

        let newDropButton = UIButton()
        newDropButton.setTitle("드랍", for: .normal)
        newDropButton.setTitleColor(.white, for: .normal)
        newDropButton.setTitleColor(.lightGray, for: .highlighted)
        newDropButton.titleLabel?.font = .pretendard(size: 20, weightName: .bold)

        let newLikeButton = UIButton()
        newLikeButton.setTitle("좋아요", for: .normal)
        newLikeButton.setTitleColor(UIColor.gray400, for: .normal)
        newLikeButton.setTitleColor(UIColor(hexString: "#43464B"), for: .highlighted)
        newLikeButton.titleLabel?.font = .pretendard(size: 20, weightName: .bold)

        let newLabel = UILabel()
        newLabel.text = "전체 0개"
        newLabel.textColor = UIColor.gray400
        newLabel.font = .pretendard(size: 14, weightName: .regular)

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

        return newStackView
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
