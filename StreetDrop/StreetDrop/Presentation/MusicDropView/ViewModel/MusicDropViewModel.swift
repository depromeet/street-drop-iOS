//
//  MusicDropViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/21.
//

import Foundation

import RxSwift
import RxRelay

final class MusicDropViewModel {
    private let droppingInfo: DroppingInfo
    private let adressManager: AdressManager
    private let disposeBag: DisposeBag = DisposeBag()
    var locationTitle: BehaviorRelay<(adress: String, text: String)>
    var albumImage: BehaviorRelay<Data?>
    var MusicTitle: Observable<String>
    var artistTitle: Observable<String>
    var commentPalceHolder: Observable<String>
    var commentGuidanceText: Observable<String>
    var dropButtonTitle: Observable<String>
    var errorDescription: BehaviorRelay<String?>

    init (
        droppingInfo: DroppingInfo,
        adressManager: AdressManager = DefaultAdressManager()
    ) {
        self.droppingInfo = droppingInfo
        self.adressManager = adressManager
        self.albumImage = BehaviorRelay(value: nil)
        self.locationTitle = BehaviorRelay(value: (adress: "여기", text: "여기에\n음악을 드랍할게요"))
        self.MusicTitle = Observable<String>.just(droppingInfo.music.title)
        self.artistTitle = Observable<String>.just(droppingInfo.music.artist)
        self.commentPalceHolder = Observable<String>.just("음악에 대해 하고싶은 말이 있나요?")
        self.dropButtonTitle = Observable<String>.just("드랍하기")
        self.commentGuidanceText = Observable<String>
            .just("• 텍스트는 생략이 가능하며 욕설, 성희롱, 비방과 같은 내용은 삭제합니다")
        self.errorDescription = BehaviorRelay(value: nil)
    }

    func fetchAdress() {
        adressManager.fetchAdress(
            latitude: droppingInfo.location.latitude,
            longitude: droppingInfo.location.longitude
        )
        .subscribe {
            if let adress = $0.element {
                self.locationTitle
                    .accept((adress: adress, text: "'\(adress)' 위치에 \n 음악을 드랍할게요"))
            }
        }
        .disposed(by: disposeBag)
    }

    func fetchAlbumImage() {
        if let albumImageUrl = URL(string: droppingInfo.music.albumImage) {
            DispatchQueue.global().async {
                do {
                    self.albumImage.accept(try Data(contentsOf: albumImageUrl))
                } catch {
                    self.errorDescription.accept("albumImage 불러오기에 실패했습니다")
                }
            }
        }
    }

    func drop(content: String) {
        droppingInfo.drop(adress: locationTitle.value.adress, content: content)
            .subscribe { response in
                if !(200...299).contains(response) {
                    self.errorDescription.accept("저장에 실패했습니다")
                }
            } onFailure: { error in
                self.errorDescription.accept("저장에 실패했습니다")
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
