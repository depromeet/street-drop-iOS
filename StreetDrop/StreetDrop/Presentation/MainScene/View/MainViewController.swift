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
    private var viewModel: MainViewModel
    private let currentLocationMarker = NMFMarker()
    private let disposeBag = DisposeBag()
    private let circleRadius: Double = 500

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.locationManager.viewControllerDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindAction()
        self.bindViewModel()

        viewModel.locationManager.viewControllerDelegate = self
    }
    
    // MARK: - UI
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        mapView.minZoomLevel = 14.0
        mapView.maxZoomLevel = 14.0
        return mapView
    }()
    
    private lazy var locationOverlay: NMFLocationOverlay = {
        let locationOverlay = self.naverMapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "locationOverlayIcon")
        locationOverlay.circleRadius = circleRadius / naverMapView.projection.metersPerPixel()
        locationOverlay.circleColor = UIColor(red: 0.408, green: 0.937, blue: 0.969, alpha: 0.16)
        
        return locationOverlay
    }()
    
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 2.0 / 255.0, green: 4.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
        return view
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationIcon.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.867, green: 0.902, blue: 0.942, alpha: 1)
        label.text = "위치 정보 없음"
        return label
    }()
    
    private lazy var musicDroppedCountContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(red: 0.068, green: 0.101, blue: 0.15, alpha: 1)
        return view
    }()
    
    private lazy var musicDroppedCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.408, green: 0.396, blue: 0.971, alpha: 1)
        label.text = "드랍된 음악 0개"
        return label
    }()
    
    private lazy var bottomBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "bottomBar.png")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "homeButton.png"), for: .normal)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "notificationButton.png"), for: .normal)
        return button
    }()
    
    private lazy var musicDropButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "musicDropButton.png"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var droppedMusicWithinAreaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: 260)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DroppedMusicWithinAreaCollectionViewCell.self, forCellWithReuseIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier)
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var bottomCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bottomCover.png")
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var backToMapButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        return button
    }()
}

private extension MainViewController {
    
    // MARK: - UI
    
    func configureUI() {
        
        // MARK: - NavigationBar
        
        self.navigationController?.isNavigationBarHidden = true
        
        // MARK: - Map View
        
        self.view.addSubview(self.naverMapView)
        self.naverMapView.frame = self.view.frame
        
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
            make.height.equalTo(260)
        }
        self.droppedMusicWithinAreaCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.setupInitialOffset()
    }
    
    // MARK: - Action Binding
    
    private func bindAction() {
        backToMapButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3, animations: {
                    self.droppedMusicWithinAreaCollectionView.snp.remakeConstraints { make in
                        make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                        make.top.equalTo(self.view.snp.bottom)
                        make.height.equalTo(260)
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
                    
                    for i in 0..<self.viewModel.musicWithinArea.count {
                        guard let cell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell else { continue }
                        cell.setComment(isPresented: false)
                    }
                })
            }
            .disposed(by: disposeBag)
        
        musicDropButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      self.viewModel.locationManager.checkAuthorizationStatus()
                else { return }
                
                let searchingMusicViewController = SearchingMusicViewController(viewModel: DefaultSearchingMusicViewModel(
                    location: self.viewModel.location,
                    address: self.viewModel.address)
                )
                self.navigationController?.pushViewController(
                    searchingMusicViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)

        droppedMusicWithinAreaCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                let communityViewModel = CommunityViewModel(
                    communityInfos: self.viewModel.musicWithinArea,
                    index: indexPath.row
                )

                let communityViewController = CommunityViewController(viewModel: communityViewModel)

                self.navigationController?.pushViewController(
                    communityViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    func bindPOI(_ poi: NMFMarker) {
        poi.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            guard let self = self else { return true }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.droppedMusicWithinAreaCollectionView.isHidden = false
                self.bottomCoverImageView.isHidden = false
                self.backToMapButton.isHidden = false
                
                self.droppedMusicWithinAreaCollectionView.snp.remakeConstraints { make in
                    make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
                    make.height.equalTo(260)
                }
                self.bottomCoverImageView.snp.remakeConstraints { make in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(152)
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
                guard let currentCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: Int(poi.tag) + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell else { return }
                currentCell.setComment(isPresented: true)
            })
            
            guard let layout = self.droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return true }
            let cellWidth = layout.itemSize.width
            let multiplier = CGFloat(poi.tag)
            self.droppedMusicWithinAreaCollectionView.setContentOffset(
                CGPoint(x: cellWidth * multiplier, y: .zero),
                animated: false
            )
        
            return true
        }
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        let input = MainViewModel.Input(
            locationUpdated: viewModel.locationUpdated
        )
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.location
            .bind(onNext: { [weak self] location in
                self?.drawCurrentLocationMarker(location: location)
            })
            .disposed(by: disposeBag)
        
        output.location
            .take(1) // 앱 실행시에 한번만 현재위치로 카메라 이동
            .bind(onNext: { [weak self] location in
                self?.moveCameraToCurrentLocation(location: location)
            })
            .disposed(by: disposeBag)
        
        output.pois
            .bind(onNext: { [weak self] pois in
                for (tag, poi) in pois.enumerated() {
                    self?.drawPOI(tag: tag + 1, item: poi)
                }
            })
            .disposed(by: disposeBag)
        
        output.musicCount
            .bind(onNext: { [weak self] musicCount in
                self?.musicDroppedCountLabel.text = "드랍된 음악 \(musicCount)개"
            })
            .disposed(by: disposeBag)
        
        output.address
            .bind(onNext: { [weak self] address in
                self?.locationLabel.text = address
            })
            .disposed(by: disposeBag)
        
        output.musicWithinArea
            .bind(to: droppedMusicWithinAreaCollectionView.rx.items(cellIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier, cellType: DroppedMusicWithinAreaCollectionViewCell.self)) { index, item, cell in
                cell.setData(item: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != droppedMusicWithinAreaCollectionView { return }
        guard let layout = droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width
        let estimatedIndex = scrollView.contentOffset.x / cellWidth
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        targetContentOffset.pointee = CGPoint(
            x: (CGFloat(index) * cellWidth),
            y: 0
        )
        for i in 0..<viewModel.musicWithinArea.count {
            guard let cell = droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell else { continue }
            cell.setComment(isPresented: false)
        }
        guard let currentCell = droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell else { return }
        currentCell.setComment(isPresented: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != droppedMusicWithinAreaCollectionView { return }
        guard let layout = droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let count = viewModel.musicWithinArea.count
        let cellWidth = layout.itemSize.width
        
        if scrollView.contentOffset.x < cellWidth {
            scrollView.setContentOffset(
                .init(x: scrollView.contentSize.width - (cellWidth * 3), y: 0),
                animated: false
            )
        }
        if scrollView.contentOffset.x > cellWidth * Double(count - 3) {
            scrollView.setContentOffset(
                .init(x: cellWidth, y: 0),
                animated: false
            )
        }
    }

    func setupInitialOffset() {
        guard let layout = droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width
        droppedMusicWithinAreaCollectionView.setContentOffset(
            CGPoint(x: cellWidth, y: .zero),
            animated: false
        )
    }
}

// MARK: - Map

private extension MainViewController {
    func drawCurrentLocationMarker(location: CLLocation) {
        locationOverlay.location = NMGLatLng(lat: location.coordinate.latitude,
                                             lng: location.coordinate.longitude)
    }
    
    func moveCameraToCurrentLocation(location: CLLocation) {
        self.naverMapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude,
                                                               lng: location.coordinate.longitude)))
    }
    
    func drawPOI(tag: Int, item: PoiEntity) {
        let poi = NMFMarker()
        poi.tag = UInt(tag)
        UIImage.load(with: item.imageURL)
            .subscribe(onNext: { image in
                guard let image = image else { return }
                let originalImage = image
                let newSize = CGSize(width: 50, height: 50)
                let resizedImage = originalImage.resized(to: newSize)
                // FIXME: 추후 마커틀 + 앨범이미지로 수정 필요
                // poi.iconImage = NMFOverlayImage(image: UIImage(named: "musicMarker") ?? UIImage())
                poi.iconImage = NMFOverlayImage(image: resizedImage ?? UIImage())
            })
            .disposed(by: disposeBag)
        
        poi.position = NMGLatLng(lat: item.lat, lng: item.lon)
        poi.mapView = self.naverMapView
        poi.globalZIndex = 400000 // 네이버맵 sdk 오버레이 가이드를 참고한 zIndex 설정
        bindPOI(poi)
    }
}

//MARK: - 위치 권한 요청을 위해 설정으로 이동 유도 Alert
extension MainViewController: Alertable {
    func requestLocationService() {
        showLocationServiceRequestAlert()
    }
}
