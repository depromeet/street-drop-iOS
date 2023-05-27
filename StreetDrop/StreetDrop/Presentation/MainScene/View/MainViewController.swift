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
        locationLabel.text = "미추홀구 용현1.4동"
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
        musicDroppedCountLabel.text = "드랍된 음악 15개"
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
    
    let music1 = CommunityInfo.Music.init(
        title: "LAST DANCE",
        artist: "BIGBANG",
        albumImage: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/5b/9b/8e/5b9b8ef2-998e-1210-8454-dfebfbf6271c/BB_COVER_IMAGE_4000.jpg/500x500bb.jpg",
        genre: ["K-Pop", "음악", "팝"]
    )
    
    let music2 = CommunityInfo.Music.init(
        title: "봄여름가을겨울 (Still Life)",
        artist: "BIGBANG",
        albumImage: "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/f6/67/3a/f6673a7c-e2bc-8084-f8b6-523cad1ab277/BIGBANG_Still_Life.jpg/500x500bb.jpg",
        genre: ["K-Pop", "음악", "팝"]
    )
    
    let music3 = CommunityInfo.Music.init(
        title: "삐딱하게",
        artist: "G-DRAGON",
        albumImage: "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/6f/ea/f0/6feaf05d-1c45-a7ac-479e-f294d0ca4b70/8806197910472.jpg/500x500bb.jpg",
        genre: ["힙합/랩", "음악", "팝", "K-Pop"]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindAction()
        self.bindViewModel()
        
        self.locationManager = LocationManager()
        self.locationManager?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
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
        
        musicDropButton.rx.tap
            .bind {
                let searchingMusicViewController = SearchingMusicViewController()
                self.navigationController?.pushViewController(
                    searchingMusicViewController,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        self.droppedMusicWithinAreaCollectionView.rx.itemSelected
            .bind { indexPath in
                
                
                let user1 = CommunityInfo.User.init(nickname: "박중규",
                                                    profileImage: "https://s3.orbi.kr/data/file/united/35546557a06831597f6e7851cb6c86e9.jpg",
                                                    musicApp: "youtubemusic"
                )
                
                let user2 = CommunityInfo.User.init(nickname: "써니 쿠키",
                                                    profileImage: "https://accounts.kakao.com/assets/weblogin/img_profile.png",
                                                    musicApp: "youtubemusic"
                )
                
                let user3 = CommunityInfo.User.init(nickname: "조셉촤",
                                                    profileImage: "https://ssl.pstatic.net/static/cafe/cafe_pc/default/cafe_profile_363.png",
                                                    musicApp: "youtubemusic"
                )
                
                let community1 = CommunityInfo(adress: "미추홀구 용현1.4동",
                                               music: self.music1,
                                               comment: "TESTTESTTESTTEST",
                                               user: user1,
                                               dropDate: "2023-05-26 01:13:14"
                )
                
                let community2 = CommunityInfo(adress: "미추홀구 용현1.4동",
                                               music: self.music2,
                                               comment: "테스트더미 만들기귀찮아 죽것다아아\n두번째줄\n세번째줄\n네번째줄",
                                               user: user2,
                                               dropDate: "2023-05-21 01:13:14"
                )
                
                let community3 = CommunityInfo(adress: "미추홀구 용현1.4동",
                                               music: self.music3,
                                               comment: "중간발표 잘할수 있을까요\n드디어 중간발표\n최종발표까지5조화이팅!!!",
                                               user: user3,
                                               dropDate: "2023-05-21 01:13:14"
                )
                
                let communityViewController = CommunityViewController(
                    viewModel: CommunityViewModel(
                        communityInfos: [community1, community2, community3],
                        index: 2
                    )
                )
                
                self.navigationController?.pushViewController(
                    communityViewController,
                    animated: true
                )
                
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
        Observable.of([self.music1, self.music2, self.music3])
            .observe(on: MainScheduler.instance)
            .bind(to: droppedMusicWithinAreaCollectionView.rx.items(cellIdentifier: DroppedMusicWithinAreaCollectionViewCell.identifier, cellType: DroppedMusicWithinAreaCollectionViewCell.self)) { index, item, cell in
                cell.setData(musicTitle: item.title, singerName: item.artist, albumImage: item.albumImage)
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
