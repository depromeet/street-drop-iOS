//
//  SettingPushNotificationCell.swift
//  StreetDrop
//
//  Created by jihye kim on 15/06/2024.
//

import RxSwift
import UIKit
import UserNotifications

class SettingPushNotificationCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private let customSwitch: CustomSwitch = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureNotifications()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.setLineHeight(lineHeight: 20)
        label.textColor = .gray100
        label.numberOfLines = 1
        
        return label
    }()
    
    func configure(with item: SettingItem) {
        infoLabel.text = item.title
    }
}

private extension SettingPushNotificationCell {
    func configureUI() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray800
        
        [
            self.infoLabel,
            self.customSwitch
        ].forEach {
            self.addSubview($0)
        }
        
        self.infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        self.customSwitch.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configureNotifications() {
        customSwitch.switchEvent
            .bind {
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNotificationSettings),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        checkNotificationSettings()
    }
    
    @objc func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.customSwitch.setOnSwitchUI(isOn: settings.authorizationStatus == .authorized)
            }
        }
    }
}
