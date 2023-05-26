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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width * 1.125 / 3)
        layout.minimumLineSpacing = 0
        let droppedMusicWithinAreaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        droppedMusicWithinAreaCollectionView.register(DroppedMusicWithinAreaCollectionViewCell.self, forCellWithReuseIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier)
        droppedMusicWithinAreaCollectionView.isPagingEnabled = false
        droppedMusicWithinAreaCollectionView.decelerationRate = .fast
        droppedMusicWithinAreaCollectionView.showsHorizontalScrollIndicator = false
        droppedMusicWithinAreaCollectionView.backgroundColor = .clear
        droppedMusicWithinAreaCollectionView.isHidden = true
        return droppedMusicWithinAreaCollectionView
    }()
    private let bottomCoverImageView: UIImageView = {
        let bottomCoverImageView = UIImageView()
        bottomCoverImageView.image = UIImage(named: "bottomCover.png")
        bottomCoverImageView.isHidden = true
        return bottomCoverImageView
    }()
    private let backToMapButton: UIButton = {
        let backToMapButton = UIButton()
        backToMapButton.isHidden = true
        return backToMapButton
    }()
    
    private let viewModel = MainViewModel()
    private var locationManager: LocationManager?
    private let currentLocationMarker = NMFMarker()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindAction()
        self.bindViewModel()
        
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
        
        // MARK: - Back To Map Button
        
        self.view.addSubview(backToMapButton)
        self.backToMapButton.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        // MARK: - Bottom Cover ImageView
        
        self.view.addSubview(self.bottomCoverImageView)
        self.bottomCoverImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(152)
        }
        
        // MARK: - Dropped Music Within Area CollectionView
        
        self.view.addSubview(self.droppedMusicWithinAreaCollectionView)
        self.droppedMusicWithinAreaCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(UIScreen.main.bounds.width * 1.125 / 3 + 35)
        }
        self.droppedMusicWithinAreaCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.bindCardListCollectionView()
    }
    
    // MARK: - Action Binding
    
    private func bindAction() {
        backToMapButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.5, animations: {
                    self.droppedMusicWithinAreaCollectionView.snp.remakeConstraints { make in
                        make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                        make.top.equalTo(self.view.snp.bottom)
                        make.height.equalTo(UIScreen.main.bounds.width * 1.125 / 3 + 35)
                    }
                    self.bottomCoverImageView.snp.remakeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.equalTo(self.view.snp.bottom)
                        make.height.equalTo(152)
                    }
                    
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    
                    self.droppedMusicWithinAreaCollectionView.isHidden = true
                    self.bottomCoverImageView.isHidden = true
                    self.backToMapButton.isHidden = true
                })
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        Observable.of([
            (37.450019, 126.653485),
            (37.4513, 126.6565),
            (37.4553, 126.651),
        ])
            .bind(onNext: { [weak self] coordList in
                coordList.forEach {
                    self?.drawMusicMarker(lat: $0.0, lng: $0.1)
                    print("\($0.0) \($0.1)")
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Draw Marker
    private func drawMusicMarker(lat: Double, lng: Double) {
        let musicMarker = NMFMarker()
        musicMarker.iconImage = NMFOverlayImage(image: UIImage(named: "musicMarker") ?? UIImage())
        musicMarker.position = NMGLatLng(lat: lat, lng: lng)
        musicMarker.mapView = self.mapView
        bindMusicMarker(musicMarker: musicMarker)
    }
    
    private func bindMusicMarker(musicMarker: NMFMarker) {
        musicMarker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            guard let self = self else { return true }
            UIView.animate(withDuration: 0.5, animations: {
                self.droppedMusicWithinAreaCollectionView.isHidden = false
                self.bottomCoverImageView.isHidden = false
                self.backToMapButton.isHidden = false

                self.droppedMusicWithinAreaCollectionView.snp.remakeConstraints { make in
                    make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(35)
                    make.height.equalTo(UIScreen.main.bounds.width * 1.125 / 3 + 35)
                }
                self.bottomCoverImageView.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(152)
                }

                self.view.layoutIfNeeded()
            })
            return true
        }
    }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func bindCardListCollectionView() {
        Observable.of([0, 1, 2, 3, 4, 5])
            .observe(on: MainScheduler.instance)
            .bind(to: droppedMusicWithinAreaCollectionView.rx.items(cellIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier, cellType: DroppedMusicWithinAreaCollectionViewCell.self)) { index, item, cell in
                cell.setData(musicTitle: "음악 이름", singerName: "가수 이름")
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
            index = Int(ceil(estimatedIndex)) < [0, 1, 2, 3, 4, 5].count ? Int(ceil(estimatedIndex)) : [0, 1, 2, 3, 4, 5].count - 1
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
