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
import RxRelay
import RxSwift
import SnapKit

final class MainViewController: UIViewController, Toastable {
    private var viewModel: MainViewModel
    private let currentLocationMarker = NMFMarker()
    private let disposeBag = DisposeBag()
    private let circleRadius: Double = 500
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let viewWillAppearEvent = PublishRelay<Void>()
    private let poiMarkerDidTapEvent = PublishRelay<NMFMarker>()
    private let cameraDidStopEvent = PublishRelay<(latitude: Double, longitude: Double)>()
    
    var cellWidth: Double? {
        guard let layout = self.droppedMusicWithinAreaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return nil }
        return layout.itemSize.width
    }

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.locationManager.viewControllerDelegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindAction()
        self.bindViewModel()

        viewModel.locationManager.viewControllerDelegate = self
        self.viewDidLoadEvent.accept(Void())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearEvent.accept(Void())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UI
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        mapView.addCameraDelegate(delegate: self)
        mapView.extent = NMGLatLngBounds(
            southWestLat: 33,
            southWestLng: 123,
            northEastLat: 42,
            northEastLng: 133
        )
        mapView.minZoomLevel = 5
        
        return mapView
    }()
    
    private lazy var locationOverlay: NMFLocationOverlay = {
        let locationOverlay = self.naverMapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "locationOverlayIcon")
        locationOverlay.circleRadius = circleRadius / naverMapView.projection.metersPerPixel()
        locationOverlay.circleColor = UIColor.primary500_16
        
        return locationOverlay
    }()
    
    private lazy var topCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "topCover")
        return imageView
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.backgroundColor = .clear
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myLocationButton.png"), for: .normal)
        return button
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationIcon.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 20, weightName: .bold)
        label.textColor = UIColor.gray50
        label.text = "위치 정보 없음"
        return label
    }()
    
    private lazy var musicDroppedCountContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.gray900_75
        return view
    }()
    
    private lazy var musicDroppedCountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weightName: .medium)
        label.textColor = UIColor.white_60
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
        button.setImage(UIImage(named: "homeButton.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.primary400
        return button
    }()
    
    private lazy var myPageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "myPageButton.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
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
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        collectionView.addGestureRecognizer(panGesture)
        collectionView.isScrollEnabled = false

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
        
        // MARK: - Top Cover ImageView
        
        self.view.addSubview(self.topCoverImageView)
        self.topCoverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - Location StackView
        
        self.view.addSubview(self.locationStackView)
        self.locationStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        // MARK: - Location Icon ImageView
        
        self.locationStackView.addArrangedSubview(self.locationIconImageView)
        self.locationIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        // MARK: - Location Label
        
        self.locationStackView.addArrangedSubview(self.locationLabel)
        
        // MARK: - Music Dropped Count Container View
        
        self.view.addSubview(self.musicDroppedCountContainerView)
        self.musicDroppedCountContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.locationStackView.snp.bottom).offset(10)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - Music Dropped Count Label
        
        self.musicDroppedCountContainerView.addSubview(self.musicDroppedCountLabel)
        self.musicDroppedCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        // MARK: - My Location Button
        
        self.view.addSubview(self.myLocationButton)
        self.myLocationButton.snp.makeConstraints {
            $0.centerY.equalTo(self.musicDroppedCountContainerView)
            $0.width.height.equalTo(38.4)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(28.8)
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
        
        // MARK: - My Page Button
        
        self.bottomBarImageView.addSubview(self.myPageButton)
        self.myPageButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(self.myPageButton.snp.height)
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
        self.droppedMusicWithinAreaCollectionView.delegate = self
        self.setupInitialOffset()
    }
    
    // MARK: - Action Binding
    
    private func bindAction() {
        backToMapButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // 다이얼이 내려가는 경우
                self.dismissDial()
            }
            .disposed(by: disposeBag)
        
// TODO: 1차 앱스토어 배포때는 실시간 위치정보 갱신을 하지 않기에, 추후 드랍하기 버튼 누를 시, 실제 사용자 위치정보는 좀 더 검토 필요
        musicDropButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      self.viewModel.locationManager.checkAuthorizationStatus()
                else { return }
                
                let searchingMusicViewController = SearchingMusicViewController(
                    viewModel: DefaultSearchingMusicViewModel(
                        location: self.viewModel.location
                    )
                )
                self.navigationController?.pushViewController(
                    searchingMusicViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)

        droppedMusicWithinAreaCollectionView.rx.itemSelected
            .do(afterNext: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.dismissDial()
                }
            })
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                let communityViewModel = CommunityViewModel(
                    communityInfos: self.viewModel.musicWithinArea,
                    index: indexPath.row
                )

                communityViewModel.blockSuccessToast
                    .bind { [weak self] toastTitle in
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.showSuccessNormalToast(
                            text: toastTitle,
                            bottomInset: 96,
                            duration: .now()+3
                        )
                    }.disposed(by: self.disposeBag)

                let communityViewController = CommunityViewController(viewModel: communityViewModel)

                self.navigationController?.pushViewController(
                    communityViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        myPageButton.rx.tap
            .bind { [weak self] in
                let myPageViewController = MyPageViewController(viewModel: MyPageViewModel())
                self?.navigationController?.pushViewController(
                    myPageViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Binding
    
    private func bindViewModel() {
        let input = MainViewModel.Input(
            viewDidLoadEvent: self.viewDidLoadEvent,
            viewWillAppearEvent: self.viewWillAppearEvent,
            poiMarkerDidTapEvent: self.poiMarkerDidTapEvent,
            cameraDidStopEvent: self.cameraDidStopEvent,
            homeButtonDidTapEvent: self.homeButton.rx.tap,
            myLocationButtonDidTapEvent: self.myLocationButton.rx.tap
        )
        let output = viewModel.convert(input: input, disposedBag: disposeBag)
        
        output.location
            .bind(onNext: { [weak self] location in
                self?.drawCurrentLocationMarker(location: location)
            })
            .disposed(by: disposeBag)
        
        output.cameraShouldGoCurrentLocation
            .bind { [weak self] location in
                self?.moveCameraToCurrentLocation(location: location)
            }
            .disposed(by: disposeBag)
        
        output.pois
            .bind(onNext: { [weak self] pois in
                self?.removeAllPOIMarkers()
                let pois = pois.sorted { $0.id < $1.id }
                for poi in pois {
                    self?.setPOIMarker(item: poi, poiID: poi.id)
                }
            })
            .disposed(by: disposeBag)
        
        output.musicCount
            .bind(onNext: { [weak self] musicCount in
                self?.musicDroppedCountLabel.text = "드랍된 음악 \(musicCount)개"
            })
            .disposed(by: disposeBag)
        
        output.cameraAddress
            .bind(onNext: { [weak self] address in
                self?.locationLabel.text = address
            })
            .disposed(by: disposeBag)
        
        output.musicWithinArea
            .bind(to: droppedMusicWithinAreaCollectionView.rx.items(cellIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier, cellType: DroppedMusicWithinAreaCollectionViewCell.self)) { index, item, cell in
                cell.setData(item: item)
            }
            .disposed(by: disposeBag)
        
        output.tappedPOIIndex
            .bind { index in
                if self.viewModel.musicWithinArea.count > 3 {
                    self.viewModel.currentIndex = index + 2
                } else {
                    self.viewModel.currentIndex = index
                }
                let currentIndex = self.viewModel.currentIndex
                guard let cellWidth = self.cellWidth else { return }

                self.droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth * CGFloat(currentIndex - 1), y: .zero),
                    animated: false
                )
                //  다이얼이 올라오는 경우
                self.presentDial(currentIndex: currentIndex)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func setupInitialOffset() {
        guard let cellWidth = self.cellWidth else { return }
        droppedMusicWithinAreaCollectionView.setContentOffset(
            CGPoint(x: cellWidth, y: .zero),
            animated: false
        )
    }
    
    func presentDial(currentIndex: Int) {
        UIView.animate(withDuration: 0.3, animations: {
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
            
            guard let cellWidth = self.cellWidth else { return }
            self.droppedMusicWithinAreaCollectionView.setContentOffset(
                CGPoint(x: cellWidth * CGFloat(currentIndex - 1), y: .zero),
                animated: false
            )
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                    middleCell.middleCell()
                }
        
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func dismissDial() {
        let music = self.viewModel.musicWithinArea[self.viewModel.currentIndex]
        let poiID = music.id
        guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
        self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
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
            
            if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                middleCell.sideCell()
            }
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.droppedMusicWithinAreaCollectionView.isHidden = true
            self.bottomCoverImageView.isHidden = true
            self.backToMapButton.isHidden = true
        })
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: droppedMusicWithinAreaCollectionView)
            let targetIndex = (velocity.x > 0) ? viewModel.currentIndex - 1 : viewModel.currentIndex + 1
            scrollToItem(at: targetIndex)
        default:
            break
        }
    }

    func scrollToItem(at index: Int) {
        guard let cellWidth = self.cellWidth else { return }
        // 무한스크롤 O
        if viewModel.musicWithinArea.count > 3 {
            if index == 1 { // 맨 왼쪽 도달
                if let preRightCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                    preRightCell.sideCell() {
                        let music = self.viewModel.musicWithinArea[index + 1]
                        let poiID = music.id
                        guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                        self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                    }
                }
                
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth * CGFloat(viewModel.musicWithinArea.count - 3), y: .zero),
                    animated: false
                )
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth * CGFloat(viewModel.musicWithinArea.count - 4), y: .zero),
                    animated: true
                )
                self.view.layoutIfNeeded()
                viewModel.currentIndex = viewModel.musicWithinArea.count - 3
                
                if let curRightCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                    curRightCell.middleCell() {
                        let music = self.viewModel.musicWithinArea[self.viewModel.currentIndex + 1]
                        let poiID = music.id
                        guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                        self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                    }
                }
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.2) {
                    if let rightCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        rightCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[self.viewModel.currentIndex + 1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    
                    if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        middleCell.middleCell() {
                            let music = self.viewModel.musicWithinArea[self.viewModel.currentIndex]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                        }
                    }
                    self.view.layoutIfNeeded()
                }
            }
            else if index == (viewModel.musicWithinArea.count - 2) { // 맨 오른쪽 도달
                if let preLeftCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                    preLeftCell.sideCell() {
                        let music = self.viewModel.musicWithinArea[index - 1]
                        let poiID = music.id
                        guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                        self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                    }
                }
                
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: 0, y: .zero),
                    animated: false
                )
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth, y: .zero),
                    animated: true
                )
                self.view.layoutIfNeeded()
                viewModel.currentIndex = 2
                
                if let curLeftCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                    curLeftCell.middleCell() {
                        let music = self.viewModel.musicWithinArea[1]
                        let poiID = music.id
                        guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                        self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                    }
                }
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.2) {
                    if let leftCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        leftCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: self.viewModel.currentIndex, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        middleCell.middleCell() {
                            let music = self.viewModel.musicWithinArea[self.viewModel.currentIndex]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                        }
                    }
                    self.view.layoutIfNeeded()
                }
            }
            else { // 중간
                UIView.animate(withDuration: 0.2) {
                    if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        middleCell.middleCell() {
                            let music = self.viewModel.musicWithinArea[index]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                        }
                    }
                    
                    if let leftCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        leftCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[index - 1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    
                    if let rightCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        rightCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[index + 1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    
                    self.view.layoutIfNeeded()
                }
                
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth * CGFloat(index - 1), y: .zero),
                    animated: true
                )
                viewModel.currentIndex = index
            }
        }
        // 무한스크롤 X
        else {
            if (index == -1) || (index  == viewModel.musicWithinArea.count) { // 양 끝
                return
            }
            else { // 중간
                UIView.animate(withDuration: 0.2) {
                    if let middleCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        middleCell.middleCell() {
                            let music = self.viewModel.musicWithinArea[index]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                        }
                    }
                    
                    if let leftCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        leftCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[index - 1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    
                    if let rightCell = self.droppedMusicWithinAreaCollectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? DroppedMusicWithinAreaCollectionViewCell {
                        rightCell.sideCell() {
                            let music = self.viewModel.musicWithinArea[index + 1]
                            let poiID = music.id
                            guard let poiMarker = self.viewModel.poiDict[poiID] else { return }
                            self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: false)
                        }
                    }
                    
                    self.view.layoutIfNeeded()
                }
                
                droppedMusicWithinAreaCollectionView.setContentOffset(
                    CGPoint(x: cellWidth * CGFloat(index - 1), y: .zero),
                    animated: true
                )
                viewModel.currentIndex = index
            }
        }
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
        self.naverMapView.moveCamera(NMFCameraUpdate(zoomTo: 14))
        self.locationOverlay.circleRadius = circleRadius / naverMapView.projection.metersPerPixel()
    }
    
    func combineImages(markerFrame: UIImage, album: UIImage) -> UIImage? {
        let size = markerFrame.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let albumRect = CGRect(x: 3, y: 3, width: album.size.width, height: album.size.height)
        album.draw(in: albumRect)

        let markerRect = CGRect(x: 0, y: 0, width: markerFrame.size.width, height: markerFrame.size.height)
        markerFrame.draw(in: markerRect, blendMode: .normal, alpha: 1)


        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return combinedImage
    }
    
    func setPOIMarker(item: PoiEntity, poiID: Int, isActivated: Bool = false) {
        let poiMarker = NMFMarker()
        poiMarker.tag = UInt(poiID)
        
        let defaultMusicMarkerImage = UIImage(named: "musicMarker") ?? UIImage()
        poiMarker.iconImage = NMFOverlayImage(image: defaultMusicMarkerImage)
        UIImage.load(with: item.imageURL, isImageFromAppleServer: true)
            .subscribe(onNext: { albumImage in
                self.viewModel.markerAlbumImages[poiID] = albumImage
                self.drawPOIMarker(poiMarker: poiMarker,poiID: poiID, isActivated: false)
            })
            .disposed(by: disposeBag)
        
        poiMarker.position = NMGLatLng(lat: item.lat, lng: item.lon)
        poiMarker.mapView = self.naverMapView
        poiMarker.globalZIndex = 400000 // 네이버맵 sdk 오버레이 가이드를 참고한 zIndex 설정
        viewModel.addPOIMarker(poiMarker)
        viewModel.poiDict[poiID] = poiMarker
        bindPOIMarker(poiMarker: poiMarker)
    }
    
    func drawPOIMarker(poiMarker: NMFMarker, poiID: Int, isActivated: Bool) {
        guard let albumImage = self.viewModel.markerAlbumImages[poiID] else { return }
        let newSize = CGSize(width: 28, height: 28)
        let resizedImage = albumImage.resized(to: newSize)?.withRoundedCorners(radius: newSize.width / 2) ?? UIImage()
        var musicMarkFrameImage: UIImage
        switch isActivated {
        case true:
            musicMarkFrameImage = UIImage(named: "musicMarkerFrameActivated") ?? UIImage()
        case false:
            musicMarkFrameImage = UIImage(named: "musicMarkerFrame") ?? UIImage()
        }
        if let combinedImage = self.combineImages(markerFrame: musicMarkFrameImage, album: resizedImage) {
            poiMarker.iconImage = NMFOverlayImage(image: combinedImage)
        }
    }
    
    func bindPOIMarker(poiMarker: NMFMarker) {
        poiMarker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            guard let self = self else { return true }
            if self.viewModel.isWithin(latitude: poiMarker.position.lat, longitude: poiMarker.position.lng) {
                let poiID = Int(poiMarker.tag)
                self.drawPOIMarker(poiMarker: poiMarker, poiID: poiID, isActivated: true)
                self.poiMarkerDidTapEvent.accept(poiMarker)
            }
            return true
        }
    }
    
    func removeAllPOIMarkers() {
        viewModel.poiDict = [:]
        viewModel.markerAlbumImages = [:]
        viewModel.removeAllPOIMarkers()
    }
}

//MARK: - 위치 권한 요청을 위해 설정으로 이동 유도 Alert
extension MainViewController: Alertable {
    func requestLocationAuthorization() {
        showLocationServiceRequestAlert()
    }
}

// MARK: - 네이버 맵 카메라 Delegate

extension MainViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        self.cameraDidStopEvent.accept((mapView.latitude, mapView.longitude))
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.locationOverlay.circleRadius = circleRadius / naverMapView.projection.metersPerPixel()
    }
}
