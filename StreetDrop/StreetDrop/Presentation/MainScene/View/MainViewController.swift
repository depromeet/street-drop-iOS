//
//  MainViewController.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import CoreLocation
import UIKit

import NMapsMap
import RxCocoa
import RxSwift
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
    private let droppedMusicWithinAreaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width * 219 / 377)
        layout.minimumLineSpacing = 0
        let droppedMusicWithinAreaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        droppedMusicWithinAreaCollectionView.register(DroppedMusicWithinAreaCollectionViewCell.self, forCellWithReuseIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier)
        droppedMusicWithinAreaCollectionView.isPagingEnabled = false
        droppedMusicWithinAreaCollectionView.decelerationRate = .fast
        droppedMusicWithinAreaCollectionView.showsHorizontalScrollIndicator = false
        droppedMusicWithinAreaCollectionView.backgroundColor = .clear
        return droppedMusicWithinAreaCollectionView
    }()
    private let bottomCoverImageView: UIImageView = {
        let bottomCoverImageView = UIImageView()
        bottomCoverImageView.image = UIImage(named: "bottomCover.png")
        return bottomCoverImageView
    }()
    
    private var locationManager: LocationManager?
    private let currentLocationMarker = NMFMarker()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        self.locationManager = LocationManager()
        self.locationManager?.delegate = self
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
        
        // MARK: - Bottom Cover ImageView
        
        self.view.addSubview(self.bottomCoverImageView)
        self.bottomCoverImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(152)
        }
        
        // MARK: - Dropped Music Within Area CollectionView
        
        self.view.addSubview(self.droppedMusicWithinAreaCollectionView)
        self.droppedMusicWithinAreaCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(UIScreen.main.bounds.width * 219 / 377)
        }
        self.droppedMusicWithinAreaCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.bindCardListCollectionView()
    }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func bindCardListCollectionView() {
        Observable.of([1, 2])
            .observe(on: MainScheduler.instance)
            .bind(to: droppedMusicWithinAreaCollectionView.rx.items(cellIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier, cellType: DroppedMusicWithinAreaCollectionViewCell.self)) { index, item, cell in
                cell.setData(musicTitle: "음악 이름", singerName: "가수 이름", comment: "동해물과 백두산이 마르고 닳도록")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Delegate Methods
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != droppedMusicWithinAreaCollectionView { return }
        guard let layout = droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidth
        var index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex)) < [1, 2].count ? Int(ceil(estimatedIndex)) : [1, 2].count - 1
        } else {
            index = Int(floor(estimatedIndex)) >= 0 ? Int(floor(estimatedIndex)) : 0
        }
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: collectionView.bounds.width / 3, bottom: 0, right: collectionView.bounds.width / 3)
    }
}

// MARK: - Map

extension MainViewController {
    func drawCurrentLocationMarker(location: CLLocation) {
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude,
                                                               lng: location.coordinate.longitude)))
        currentLocationMarker.mapView = nil
        currentLocationMarker.iconImage = NMFOverlayImage(image: UIImage(named: "locationMarker.png") ?? UIImage())
        currentLocationMarker.position = NMGLatLng(lat: location.coordinate.latitude,
                                                   lng: location.coordinate.longitude)
        currentLocationMarker.mapView = mapView
    }
}
