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
        var currentIndex: PublishRelay<Int> = .init()
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

    private(set) var communityInfos: [MusicWithinAreaEntity]
    private(set) var currentIndex: Int
    private var communityModel: CommunityModel
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(
        communityInfos: [MusicWithinAreaEntity],
        index: Int,
        communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.communityInfos = communityInfos
        self.currentIndex = index
        self.communityModel = communityModel
    }

    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                output.addressTitle.accept(self.communityInfos[self.currentIndex].address)
                self.changeCommunityInfoForIndex(index: self.currentIndex, output: output)

                // 데이터가 2,3개일 때는 무한스크롤없이 첫번째/마지막쎌이 가운데로 스크롤되게하기위해 처음/마지막에 빈쎌을 넣어준상태
                // 즉 데이터가 3개면 빈데이터+3개+빈데이터 = 5개
                if (2...3).contains(self.communityInfos.count) {
                    self.communityInfos.insert(MusicWithinAreaEntity.generateEmptyData(), at: 0)
                    self.communityInfos.append(MusicWithinAreaEntity.generateEmptyData())
                    self.currentIndex += 1
                }

                let albumImagesURL = self.communityInfos.map { $0.albumImageURL }
                output.albumImages.accept(albumImagesURL)
                output.currentIndex.accept(self.currentIndex)
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
                let id = communityInfo.id
                
                isLiked
                ? self.likeDown(itemID: id, output: output)
                : self.likeUp(itemID: id, output: output)
            }).disposed(by: disposedBag)

        return output
    }
}

//MARK: - Private
private extension CommunityViewModel {
    func changeCommunityInfoForIndex(index: Int, output: Output) {
        guard (0..<communityInfos.count).contains(index) else { return }

        let communityInfo = communityInfos[index]

        output.musicTitle.accept(communityInfo.musicTitle)
        output.artistTitle.accept(communityInfo.artist)
        output.genresText.accept(communityInfo.genre)
        output.commentText.accept(communityInfo.content)
        output.nicknameText.accept(communityInfo.userName)
        output.dateText.accept(convertDateFormat(date: communityInfo.createdAt))
        output.isLiked.accept(communityInfo.isLiked)
        output.likeCount.accept(String(communityInfo.likeCount))

        // 프로필 이미지 URL 생기면 두번째 줄로 바꾸기. 1차 배포는 애플 이미지 사용)
        output.profileImageURL.accept("person.circle")
        //output.profileImageURL.accept(communityInfo.userProfileImageURL)
    }

    func likeDown(itemID: Int, output: Output) {
        self.communityModel.likeDown(itemID: itemID)
            .subscribe(onSuccess: { response in
                guard (200...299).contains(response) else {
                    output.errorDescription.accept("좋아요취소에 실패했습니다")
                    return
                }
                
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
