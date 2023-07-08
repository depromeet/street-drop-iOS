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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindAction()
        self.bindViewModel()
    }
    
   
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "마이페이지"
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    private lazy var levelImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private lazy var levelTagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .red
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var nickNameChangeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var tapListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .gray
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var dropTapLabel: UILabel = {
       let label = UILabel()
        label.text = "드랍"
        return label
    }()
    
    private lazy var likeTapLabel: UILabel = {
       let label = UILabel()
        label.text = "좋아요"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
       let label = UILabel()
        label.text = "전체 OOO개"
        return label
    }()
    
    private lazy var dropMusicListTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var likeMusicListTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
    }()
}

private extension MyPageViewController {
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - ScrollView
        
        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        // MARK: - Level Tag Label
        
        self.containerView.addSubview(levelTagLabel)
        self.levelTagLabel.snp.makeConstraints { make in
            make.top.equalTo(levelImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Profile StackView
        
        self.containerView.addSubview(profileStackView)
        self.profileStackView.snp.makeConstraints { make in
            make.top.equalTo(levelTagLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Profile ImageView
        
        self.profileStackView.addArrangedSubview(profileImageView)
        
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
        
        // MARK: - Tap List StackView
        
        self.containerView.addSubview(tapListStackView)
        self.tapListStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // MARK: - Drop Tap Label
        
        self.tapListStackView.addArrangedSubview(dropTapLabel)
        
        // MARK: - Like Tap Label
        
        self.tapListStackView.addArrangedSubview(likeTapLabel)
        
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
            make.height.equalTo(0)
        }
        
        // MARK: - Like Music List TableView
        
        self.containerView.addSubview(likeMusicListTableView)
        self.likeMusicListTableView.snp.makeConstraints { make in
            make.top.equalTo(tapListStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
    }
    
    // MARK: - Action Binding
    
    private func bindAction() { }
    
    // MARK: - Data Binding
    
    private func bindViewModel() { }
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
