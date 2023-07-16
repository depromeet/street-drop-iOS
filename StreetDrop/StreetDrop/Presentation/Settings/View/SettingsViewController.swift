//
//  SettingsViewController.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa
import SnapKit

final class SettingsViewController: UIViewController, Toastable {
    private let viewModel: DefaultSettingsViewModel
    private let disposeBag = DisposeBag()
    private var musicAppButtons: [MusicAppButton] = []
    private let musicAppButtonEvent: PublishRelay<String> = .init()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let customSwitch: CustomSwitch = .init()
    
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
    
    private let selectingMusicAppLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "스트리밍 서비스 선택"
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = .gray100
        label.setLineHeight(lineHeight: 20)
        
        return label
    }()
    
    private lazy var selectingMusicAppStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        MusicApp.allCases.forEach { musicApp in
            let button: MusicAppButton = .init()
            button.setData(musicApp: musicApp)
            button.rx.controlEvent(.touchUpInside)
                .bind { [weak self] in
                    self?.musicAppButtonEvent.accept(musicApp.queryString)
                }
                .disposed(by: disposeBag)
                
            musicAppButtons.append(button)
        }
        musicAppButtons.forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    private let settingElementStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.layer.cornerRadius = 12
        
        return stackView
    }()
    
    private lazy var pushNotificationOnOffView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 12
        
        let label: UILabel = .init()
        label.text = "푸쉬 알림"
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .gray100
        label.numberOfLines = 1
        
        
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized, .notDetermined:
                DispatchQueue.main.async { [weak self] in
                    self?.customSwitch.setOnSwitchUI(isOn: true)
                }
            default:
                DispatchQueue.main.async { [weak self] in
                    self?.customSwitch.setOnSwitchUI(isOn: false)
                }
            }
        }
        
        customSwitch.switchEvent
            .bind {
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNotifiCations),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        [
            label,
            customSwitch
        ].forEach {
            view.addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        customSwitch.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bindViewModel()
        configureUI()
        viewDidLoadEvent.accept(Void())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
}

private extension SettingsViewController {
    func bindAction() {
        
        Observable.merge(
            self.backButton.rx.tap.asObservable()
        )
        .bind { _ in
            self.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = DefaultSettingsViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            musicAppButtonEvent: musicAppButtonEvent.asObservable()
        )
        
        let output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
        
        output.currentMusicApp
            .bind { [weak self] musicApp in
                self?.musicAppButtons.forEach {
                    if $0.musicApp == musicApp {
                        $0.setSelectedAppearance()
                    } else {
                        $0.setUnselectedAppearance()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.savedMusicAppInServer
            .bind { [weak self] savedMusicAppInServer in
                self?.musicAppButtons.forEach {
                    if $0.musicApp == savedMusicAppInServer {
                        $0.setSelectedAppearance()
                        self?.showMusicAppCheckBoxToast(
                            text: "연결 앱이 변경되었어요!",
                            bottomInset: 44,
                            duration: .now() + 3
                        )
                    } else {
                        $0.setUnselectedAppearance()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.changingMusicAppFailAlert
            .bind { [weak self] message in
                self?.showFailNormalToast(
                    text: message,
                    bottomInset: 44,
                    duration: .now() + 3
                )
            }
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor.gray900
        
        [
            self.backButton,
            self.navigationTitle
        ].forEach {
            self.navigationBar.addSubview($0)
        }
        
        [
            self.navigationBar
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
        
        let selectingMusicAppContainerView: UIView = .init()
        selectingMusicAppContainerView.backgroundColor = .gray800
        selectingMusicAppContainerView.layer.cornerRadius = 12
        
        self.view.addSubview(selectingMusicAppContainerView)
        [
            self.selectingMusicAppLabel,
            self.selectingMusicAppStackView
        ].forEach {
            selectingMusicAppContainerView.addSubview($0)
        }
        
        selectingMusicAppContainerView.snp.makeConstraints {
            $0.top.equalTo(self.navigationBar.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.selectingMusicAppLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            
        }
        
        self.selectingMusicAppStackView.snp.makeConstraints {
            $0.top.equalTo(self.selectingMusicAppLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        self.view.addSubview(settingElementStackView)
        self.settingElementStackView.addArrangedSubview(pushNotificationOnOffView)
        
        SettingsInfo.allCases.forEach { settingsInfo in
            let settingElementView: SettingElementView = .init()
            settingElementView.text = settingsInfo.rawValue
            settingElementView.settingElementDidTappedEvent
                .bind {
                    guard let url = URL(string: settingsInfo.urlAddress) else {
                        return
                    }
                    
                    UIApplication.shared.open(url)
                }
                .disposed(by: disposeBag)
            self.settingElementStackView.addArrangedSubview(settingElementView)
        }
        
        self.settingElementStackView.snp.makeConstraints {
            $0.height.equalTo(252)
            $0.top.equalTo(selectingMusicAppContainerView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func checkNotifiCations() {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized, .notDetermined:
                DispatchQueue.main.async { [weak self] in
                    self?.customSwitch.setOnSwitchUI(isOn: true)
                }
            default:
                DispatchQueue.main.async { [weak self] in
                    self?.customSwitch.setOnSwitchUI(isOn: false)
                }
            }
        }
    }
}
