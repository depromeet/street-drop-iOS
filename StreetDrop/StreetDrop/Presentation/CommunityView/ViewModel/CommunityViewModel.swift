//
//  CommunityViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import Foundation

import RxRelay
import RxSwift

final class CommunityViewModel {
    private var communityInfos: [CommunityInfo]
    private let disposeBag: DisposeBag = DisposeBag()
    private var currentIndex: BehaviorRelay<Int>

    var addressTitle:Observable<String>
    var MusicTitle: BehaviorRelay<String>
    var artistTitle: BehaviorRelay<String>
    var genresText: BehaviorRelay<[String]>
    var commentText: BehaviorRelay<String>
    var profileImage: BehaviorRelay<String>
    var nicknameText: BehaviorRelay<String>
    var dateText: BehaviorRelay<String>
    var errorDescription: BehaviorRelay<String?>

    var communityInfoCount: Int {
        return communityInfos.count
    }

    var albumImages: [String] {
        return communityInfos.map { $0.music.albumImage }
    }

    init(communityInfos: [CommunityInfo], index: Int) {
        let communityInfo = communityInfos[index]
        
        self.communityInfos = communityInfos
        self.currentIndex = BehaviorRelay(value: index)
        self.addressTitle = Observable<String>.just(communityInfo.adress)
        self.MusicTitle = BehaviorRelay(value: communityInfo.music.title)
        self.artistTitle = BehaviorRelay(value: communityInfo.music.artist)
        self.genresText = BehaviorRelay(value: communityInfo.music.genre)
        self.commentText = BehaviorRelay(value: communityInfo.comment)
        self.profileImage = BehaviorRelay(value: communityInfo.user.profileImage)
        self.nicknameText = BehaviorRelay(value: communityInfo.user.nickname)
        self.dateText = BehaviorRelay(value: communityInfo.dropDate)
        self.errorDescription = BehaviorRelay(value: nil)

        prepareInfiniteCarousel()
        bindCurrentIndex()
    }

    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer in
            DispatchQueue.global().async {
                do {
                    if let albumImageUrl = URL(string: url) {
                        let imageData = try Data(contentsOf: albumImageUrl)
                        observer.onNext(imageData)
                    }
                } catch {
                    self.errorDescription.accept("Image 불러오기에 실패했습니다")
                }
            }

            return Disposables.create()
        }
    }

    func changeCurrentMusic(to index: Int) {
        self.currentIndex.accept(index)
    }
}

//MARK: - Private
extension CommunityViewModel {
    private func prepareInfiniteCarousel() {
        // 데이터 앞 뒤2개씩 추가: origin 1,2,3,4,5 -> to be 4,5 + 1,2,3,4,5 + 1,2
        communityInfos.insert(communityInfos[communityInfos.count-1], at: 0)
        communityInfos.insert(communityInfos[communityInfos.count-2], at: 0)
        communityInfos.append(communityInfos[2])
        communityInfos.append(communityInfos[3])
        currentIndex.accept(currentIndex.value+2)
    }

    private func bindCurrentIndex() {
        currentIndex.subscribe {
            let index = $0.element ?? 0

            let communityInfo = self.communityInfos[index]
            self.MusicTitle.accept(communityInfo.music.title)
            self.artistTitle.accept(communityInfo.music.artist)
            self.genresText.accept(communityInfo.music.genre)
            self.commentText.accept(communityInfo.comment)
            self.profileImage.accept(communityInfo.user.profileImage)
            self.nicknameText.accept(communityInfo.user.nickname)
            self.dateText.accept(communityInfo.dropDate)
        }.disposed(by: disposeBag)
    }
}