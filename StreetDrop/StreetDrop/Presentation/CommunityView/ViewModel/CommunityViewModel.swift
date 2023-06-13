//
//  CommunityViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import Foundation

import RxRelay
import RxSwift

final class CommunityViewModel: ViewModel {

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let changedIndex: Observable<Int>
        let tapLikeButtonEvent: Observable<Void>
    }

    struct Output {
        var addressTitle: PublishRelay<String> = .init()
        var albumImages: PublishRelay<[String]> = .init()
        var musicTitle: PublishRelay<String> = .init()
        var artistTitle: PublishRelay<String> = .init()
        var genresText: PublishRelay<[String]> = .init()
        var commentText: PublishRelay<String> = .init()
        var profileImageURL: PublishRelay<String> = .init()
        var nicknameText: PublishRelay<String> = .init()
        var dateText: PublishRelay<String> = .init()
        var isLiked: PublishRelay<Bool> = .init()
        var likeCount: PublishRelay<String> = .init()
        var errorDescription: BehaviorRelay<String?> = .init(value: nil)
    }

    private var communityInfos: [CommunityInfo]
    private var currentIndex: Int
    private var communityModel: CommunityModel
    private let disposeBag: DisposeBag = DisposeBag()

    var communityInfoCount: Int {
        return communityInfos.count
    }
    
    init(
        communityInfos: [CommunityInfo],
        index: Int,
        communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.communityInfos = communityInfos
        self.currentIndex = index
        self.communityModel = communityModel

        prepareInfiniteCarousel()
    }

    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                output.addressTitle.accept(self.communityInfos[self.currentIndex].address)
                output.albumImages.accept(self.communityInfos.map {$0.music.albumImage} )
                self.changeCommunityInfoForIndex(index: self.currentIndex, output: output)
            }).disposed(by: disposedBag)

        input.changedIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.changeCommunityInfoForIndex(index: index, output: output)
                self.currentIndex = index
            }).disposed(by: disposedBag)

        input.tapLikeButtonEvent
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let communityInfo = self.communityInfos[self.currentIndex]
                let isLiked = communityInfo.isLiked
                let id = communityInfo.itemID
                
                isLiked
                ? self.likeDown(itemID: id, output: output)
                : self.likeUp(itemID: id, output: output)
            }).disposed(by: disposedBag)

        return output
    }
}

//MARK: - Private
private extension CommunityViewModel {
    func prepareInfiniteCarousel() {
        // 데이터 앞 뒤2개씩 추가: origin 1,2,3,4,5 -> to be 4,5 + 1,2,3,4,5 + 1,2
        communityInfos.insert(communityInfos[communityInfos.count-1], at: 0)
        communityInfos.insert(communityInfos[communityInfos.count-2], at: 0)
        communityInfos.append(communityInfos[2])
        communityInfos.append(communityInfos[3])
        currentIndex += 2
    }

    func changeCommunityInfoForIndex(index: Int, output: Output) {
        let communityInfo = communityInfos[index]

        output.musicTitle.accept(communityInfo.music.title)
        output.artistTitle.accept(communityInfo.music.artist)
        output.genresText.accept(communityInfo.music.genre)
        output.commentText.accept(communityInfo.comment)
        output.nicknameText.accept(communityInfo.user.nickname)
        output.dateText.accept(communityInfo.dropDate)
        output.isLiked.accept(communityInfo.isLiked)
        output.likeCount.accept(String(communityInfo.likeCount))
        output.profileImageURL.accept(communityInfo.user.profileImage)
    }

    func likeDown(itemID: Int, output: Output) {
        self.communityModel.likeDown(itemID: itemID)
            .subscribe(onSuccess: { response in
                guard (200...299).contains(response) else {
                    output.errorDescription.accept("좋아요취소에 실패했습니다")
                    return
                }
                print(response)
                let likeCount = self.communityInfos[self.currentIndex].likeCount

                output.isLiked.accept(false)
                output.likeCount.accept(String(likeCount-1))
                self.communityInfos[self.currentIndex].isLiked = false
                self.communityInfos[self.currentIndex].likeCount -= 1
            }, onFailure: { error in
                output.errorDescription.accept("좋아요취소에 실패했습니다")
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    func likeUp(itemID: Int, output: Output) {
        self.communityModel.likeUp(itemID: itemID)
            .subscribe(onSuccess: { response in
                guard (200...299).contains(response) else {
                    output.errorDescription.accept("좋아요에 실패했습니다")
                    return
                }
                let likeCount = self.communityInfos[self.currentIndex].likeCount

                output.isLiked.accept(true)
                output.likeCount.accept(String(likeCount+1))
                self.communityInfos[self.currentIndex].isLiked = true
                self.communityInfos[self.currentIndex].likeCount += 1
            }, onFailure: { error in
                output.errorDescription.accept("좋아요에 실패했습니다")
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    func convertDateFormat(date: String) -> String {
        //"2023-05-21 01:13:14" -> "2023.05.21"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let convertDate = dateFormatter.date(from: date) else {
            return ""
        }

        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy.MM.dd"

        return myDateFormatter.string(from: convertDate)
    }
}
