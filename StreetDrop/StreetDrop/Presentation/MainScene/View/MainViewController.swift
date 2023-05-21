//
//  MainViewController.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import UIKit

import NMapsMap
import SnapKit

final class MainViewController: UIViewController {
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        return mapView
    }()
    private let topBarView: UIView = {
        let topBarView = UIView()
        topBarView.layer.cornerRadius = 8
        topBarView.backgroundColor = UIColor(red: 2.0 / 255.0, green: 4.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
        return topBarView
    }()
    private let locationIconImageView: UIImageView = {
       let locationIconImageView = UIImageView()
        locationIconImageView.image = UIImage(named: "locationIcon.png")
        locationIconImageView.contentMode = .scaleAspectFit
        return locationIconImageView
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = UIColor(red: 0.867, green: 0.902, blue: 0.942, alpha: 1)
        locationLabel.text = "성동구 성수 1가 1동"
        return locationLabel
    }()
    private let musicDroppedCountContainerView: UIView = {
        let musicDroppedCountContainerView = UIView()
        musicDroppedCountContainerView.layer.cornerRadius = 4
        musicDroppedCountContainerView.backgroundColor = UIColor(red: 0.068, green: 0.101, blue: 0.15, alpha: 1)
        return musicDroppedCountContainerView
    }()
    private let musicDroppedCountLabel: UILabel = {
        let musicDroppedCountLabel = UILabel()
        musicDroppedCountLabel.font = .systemFont(ofSize: 12)
        musicDroppedCountLabel.textColor = UIColor(red: 0.408, green: 0.396, blue: 0.971, alpha: 1)
        musicDroppedCountLabel.text = "드랍된 음악 247개"
        return musicDroppedCountLabel
    }()
    private let bottomBarImageView: UIImageView = {
        let bottomBarImageView = UIImageView()
        bottomBarImageView.backgroundColor = .clear
        bottomBarImageView.image = UIImage(named: "bottomBar.png")
        bottomBarImageView.isUserInteractionEnabled = true
        return bottomBarImageView
    }()
    private let homeButton: UIButton = {
        let homeButton = UIButton()
        homeButton.setImage(UIImage(named: "homeButton.png"), for: .normal)
        return homeButton
    }()
    private let notificationButton: UIButton = {
        let notificationButton = UIButton()
        notificationButton.setImage(UIImage(named: "notificationButton.png"), for: .normal)
        return notificationButton
    }()
    private let musicDropButton: UIButton = {
        let musicDropButton = UIButton()
        musicDropButton.setImage(UIImage(named: "musicDropButton.png"), for: .normal)
        musicDropButton.contentVerticalAlignment = .fill
        musicDropButton.contentHorizontalAlignment = .fill
        return musicDropButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension MainViewController {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - Map View
        
        self.view.addSubview(self.mapView)
        self.mapView.frame = self.view.frame
        
        // MARK: - Top Bar View
        
        self.view.addSubview(self.topBarView)
        self.topBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(42)
        }
        
        // MARK: - Location Icon ImageView
        
        self.topBarView.addSubview(self.locationIconImageView)
        self.locationIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        // MARK: - Location Label
        
        self.topBarView.addSubview(self.locationLabel)
        self.locationLabel.snp.makeConstraints { make in
            make.left.equalTo(self.locationIconImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
        
        // MARK: - Music Dropped Count Container View
        
        self.topBarView.addSubview(self.musicDroppedCountContainerView)
        self.musicDroppedCountContainerView.snp.makeConstraints { make in
            make.width.equalTo(111)
            make.height.equalTo(26)
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        // MARK: - Music Dropped Count Label
        
        self.musicDroppedCountContainerView.addSubview(self.musicDroppedCountLabel)
        self.musicDroppedCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        // MARK: - Bottom Bar IamgeView
        
        self.view.addSubview(self.bottomBarImageView)
        self.bottomBarImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(67)
            make.height.equalTo(self.bottomBarImageView.snp.width).multipliedBy(0.2)
        }
        
        // MARK: - Home Button
        
        self.bottomBarImageView.addSubview(self.homeButton)
        self.homeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(self.homeButton.snp.height)
            make.left.equalToSuperview().inset(28)
        }
        
        // MARK: - Notification Button
        
        self.bottomBarImageView.addSubview(self.notificationButton)
        self.notificationButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(self.notificationButton.snp.height)
            make.right.equalToSuperview().inset(28)
        }
        
        // MARK: - Music Drop Button
        
        self.view.addSubview(self.musicDropButton)
        self.musicDropButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.bottomBarImageView)
            make.width.equalTo(self.bottomBarImageView).multipliedBy(0.2)
            make.height.equalTo(self.musicDropButton.snp.width)
            make.bottom.equalTo(self.bottomBarImageView.snp.bottom)
        }
        self.view.layoutIfNeeded()
        self.musicDropButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.bottomBarImageView.snp.bottom).inset(self.musicDropButton.frame.height / 3)
        }
    }
}
