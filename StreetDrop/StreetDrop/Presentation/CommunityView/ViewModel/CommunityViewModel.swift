//
//  CommunityViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/26.
//

import Foundation

import RxRelay
import RxSwift

typealias DropInfo = (isMyDrop: Bool, id: Int)

final class CommunityViewModel: ViewModel {

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let changedIndex: Observable<Int>
        let tapLikeButtonEvent: Observable<Void>
        let tapOptionButtonEvent: Observable<Void>
        let deleteEvent: Observable<Void>
        let editEvent: Observable<(editedComment: String, index: Int)>
        let blockEvent: Observable<Void>
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
        var musicApp: PublishRelay<String> = .init()
        var isLiked: PublishRelay<Bool> = .init()
        var likeCount: PublishRelay<String> = .init()
        var dropInfo: PublishRelay<DropInfo> = .init()
        var infoIsEmpty: PublishRelay<Void> = .init()
        var toast: PublishRelay<(isSuccess: Bool, title: String)> = .init()
    }

    private(set) var communityInfos: [MusicWithinAreaEntity]
    private(set) var currentIndex: Int
    private let fetchingMyInfoUseCase: FetchingMyInfoUseCase
    private let deletingMusicUseCase: DeletingMusicUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let likingUseCase: LikingUseCase
    private let fetchingSingleMusicUseCase: FetchingSingleMusicUseCase
    
    private let disposeBag: DisposeBag = DisposeBag()
    var blockSuccessToast:  PublishRelay<String> = .init()
    var itemID: Int?
    
    init(
        communityInfos: [MusicWithinAreaEntity],
        index: Int,
        fetchingMyInfoUseCase: FetchingMyInfoUseCase = DefaultFetchingMyInfoUseCase(),
        deletingMusicUseCase: DeletingMusicUseCase = DefaultDeletingMusicUseCase(),
        blockUserUseCase: BlockUserUseCase = DefaultBlockUserUseCase(),
        likingUseCase: LikingUseCase = DefaultLikingUseCase(),
        fetchingSingleMusicUseCase: FetchingSingleMusicUseCase = DefaultFetchingSingleMusicUseCase()
    ) {
        self.communityInfos = communityInfos
        self.currentIndex = index
        self.fetchingMyInfoUseCase = fetchingMyInfoUseCase
        self.deletingMusicUseCase = deletingMusicUseCase
        self.blockUserUseCase = blockUserUseCase
        self.likingUseCase = likingUseCase
        self.fetchingSingleMusicUseCase = fetchingSingleMusicUseCase
    }

    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .flatMapLatest {
                if let itemID = self.itemID {
                    return self.fetchingSingleMusicUseCase.fetchSingleMusic(itemID: itemID)
                } else {
                    return Single.create {
                        $0(.success(self.communityInfos))
                        return Disposables.create()
                    }
                }
            }
            .subscribe(with: self, onNext: { owner, musics in
                UserDefaults.standard.removeObject(forKey: UserDefaultKey.sharedMusicItemID)
                owner.communityInfos = musics
                
                if (1...3).contains(owner.communityInfos.count) {
                    owner.addEmptyInfoAtEachEnd()
                    owner.currentIndex += 1
                }
                
                output.addressTitle.accept(owner.communityInfos[owner.currentIndex].address)
                owner.changeCommunityInfoForIndex(index: owner.currentIndex, output: output)
                let albumImagesURL = owner.communityInfos.map { $0.albumImageURL }
                output.albumImages.accept(albumImagesURL)
                output.currentIndex.accept(owner.currentIndex)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let musicApp: String = fetchingMyInfoUseCase.fetchMyMusicAppFromStorage() ?? "youtubemusic"
                output.musicApp.accept(musicApp)
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
        
        input.tapOptionButtonEvent
            .subscribe(with: self, onNext: { owner, index in
                let myUserID = owner.fetchingMyInfoUseCase.fetchMyUserIDFromStorage()
                let MusicInfoUserID = owner.communityInfos[owner.currentIndex].userId
                let itemID = owner.communityInfos[owner.currentIndex].id
                output.dropInfo.accept((myUserID == MusicInfoUserID, itemID))
            }).disposed(by: disposedBag)

        input.deleteEvent
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }

                deletingMusicUseCase.execute(itemID: self.communityInfos[self.currentIndex].id)
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            self.deleteMusic(output: output)

                            let albumImagesURL = self.communityInfos.map { $0.albumImageURL }
                            output.albumImages.accept(albumImagesURL)
                            output.currentIndex.accept(self.currentIndex)
                        } else {
                            output.toast.accept(
                                (isSuccess: false, title: "삭제에 실패했습니다. 네트워크를 확인해주세요")
                            )
                        }
                    }, onFailure: { error in
                        output.toast.accept(
                            (isSuccess: false, title: "삭제에 실패했습니다. 네트워크를 확인해주세요")
                        )
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        input.editEvent
            .subscribe(onNext: { [weak self] (editedComment, index) in
                self?.communityInfos[index].content = editedComment
            }).disposed(by: disposedBag)

        input.blockEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let index = self.currentIndex
                let blockUserID = self.communityInfos[index].userId

                blockUserUseCase.execute(blockUserID)
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            self.blockSuccessToast.accept("차단이 완료되었습니다")
                        } else {
                            output.toast.accept(
                                (isSuccess: false, title: "차단에 실패했습니다. 네트워크를 확인해주세요")
                            )
                        }
                    }, onFailure: { error in
                        output.toast.accept(
                            (isSuccess: false, title: "차단에 실패했습니다. 네트워크를 확인해주세요")
                        )
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)


        return output
    }
}

//MARK: - Private
private extension CommunityViewModel {
    func changeCommunityInfoForIndex(index: Int, output: Output) {
        guard (0..<communityInfos.count).contains(index),
              communityInfos[index].albumImageURL != "" else { return }

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
        likingUseCase.likeDown(itemID: itemID)
            .subscribe(onSuccess: { response in
                guard (200...299).contains(response) else {
                    output.toast.accept((isSuccess: false, title: "네트워크를 확인해 주세요"))
                    return
                }
                
                let likeCount = self.communityInfos[self.currentIndex].likeCount

                output.isLiked.accept(false)
                output.likeCount.accept(String(likeCount-1))
                self.communityInfos[self.currentIndex].isLiked = false
                self.communityInfos[self.currentIndex].likeCount -= 1
            }, onFailure: { error in
                output.toast.accept((isSuccess: false, title: "네트워크를 확인해 주세요"))
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    func likeUp(itemID: Int, output: Output) {
        likingUseCase.likeUp(itemID: itemID)
            .subscribe(onSuccess: { response in
                guard (200...299).contains(response) else {
                    output.toast.accept((isSuccess: false, title: "네트워크를 확인해 주세요"))
                    return
                }
                let likeCount = self.communityInfos[self.currentIndex].likeCount

                output.isLiked.accept(true)
                output.likeCount.accept(String(likeCount+1))
                self.communityInfos[self.currentIndex].isLiked = true
                self.communityInfos[self.currentIndex].likeCount += 1
            }, onFailure: { error in
                output.toast.accept((isSuccess: false, title: "네트워크를 확인해 주세요"))
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
        myDateFormatter.dateFormat = "yy.MM.dd"

        return myDateFormatter.string(from: convertDate)
    }

    func deleteMusic(output: Output) {
        // 기존데이터 갯수 3개이하 / 4개이상 분기 처리 (왜냐하면 무한스크롤로 데이터 셋팅 방법이 달랐음)
        // 1️⃣ 3개이하였던 데이터라면 배열 앞뒤로 넣어줬던 빈쎌 제거하고 시작
        let musicIndex = currentIndex

        if self.communityInfos.first?.albumImageURL.isEmpty == true {
            self.removeEmptyInfoAtEachEnd()

            // 데이터 삭제
            let indexWillDelete = musicIndex-1
            communityInfos.remove(at: indexWillDelete)

            // 남은 데이터가 0개일때 -> VC: dismiss
            if communityInfos.count == 0 {
                output.infoIsEmpty.accept(())
            }

            // 남은데이터가 1개 이상일 때
            if communityInfos.count >= 1 {
                // 삭제된 index 가 마지막 index였다면 indexRange벗어남 방지를위해 index = index-1 처리
                var currentIndex = indexWillDelete

                if indexWillDelete == communityInfos.count {
                    currentIndex = indexWillDelete-1
                }

                // 무한스크롤없이 첫번째/마지막쎌이 가운데로 스크롤되게하기위해 처음/마지막에 빈쎌을 다시 넣어준다.
                self.addEmptyInfoAtEachEnd()
                currentIndex += 1
                self.changeCommunityInfoForIndex(index: currentIndex, output: output)
                self.currentIndex = currentIndex
            }

            return
        }

        // 2️⃣ 4개 이상 데이터라면 무한스크롤을 위해 앞뒤로 넣어줬던 두개씩의 데이터 제거하고 시작
        if self.communityInfos.first?.albumImageURL.isEmpty == false {
            removeOtherSideTwoInfoAtEachEnd()

            // 데이터 삭제 전 삭제할 인덱스 조정
            // [4,5]+[1,2,3,4,5]+[1,2] 에서 첫번째 데이터 1은 index2, Index 8에서 동시 사용중이었기때문에 조정필요
            var indexWillDelete = musicIndex-2
            if indexWillDelete == communityInfos.count {
                indexWillDelete = 0
            }

            //데이터삭제
            communityInfos.remove(at: indexWillDelete)

            //남은 3개 이하가됐을때 -> 무한스크롤 X
            if communityInfos.count <= 3 {
                // 삭제된 index 가 마지막 index였다면 indexRange벗어남 방지를위해 index = index-1 처리
                var currentIndex = indexWillDelete

                if indexWillDelete == communityInfos.count {
                    currentIndex = indexWillDelete-1
                }

                // 무한스크롤없이 첫번째/마지막쎌이 가운데로 스크롤되게하기위해 처음/마지막에 빈쎌을 다시 넣어준다.
                self.addEmptyInfoAtEachEnd()
                currentIndex += 1
                self.changeCommunityInfoForIndex(index: currentIndex, output: output)
                self.currentIndex = currentIndex

                return
            }

            //남은 4개 이상됐을때 -> 무한스크롤
            if communityInfos.count >= 4 {
                var currentIndex = indexWillDelete
                self.addOtherSideTwoInfoAtEachEnd()
                currentIndex+=2
                self.changeCommunityInfoForIndex(index: currentIndex, output: output)
                self.currentIndex = currentIndex
            }
        }
    }

    func addEmptyInfoAtEachEnd() {
        //ex [1, 2, 3]  ===>>> [ ] + [1, 2, 3] + [ ]
        self.communityInfos.insert(MusicWithinAreaEntity.generateEmptyData(), at: 0)
        self.communityInfos.append(MusicWithinAreaEntity.generateEmptyData())
    }

    func removeEmptyInfoAtEachEnd() {
        // ex) [ ] + [1, 2, 3] + [ ] ===>>> [1, 2, 3]
        self.communityInfos.remove(at: 0)
        self.communityInfos.remove(at: communityInfos.count-1)
    }

    func addOtherSideTwoInfoAtEachEnd() {
        //ex [1,2,3,4,5] ===>>> [4,5] + [1,2,3,4,5] + [1,2]
        let infosCount = communityInfos.count
        let lastTwo = Array(self.communityInfos[(infosCount-2)...(infosCount-1)])
        let firstTwo = Array(self.communityInfos[0...1])
        self.communityInfos = lastTwo + self.communityInfos + firstTwo
    }

    func removeOtherSideTwoInfoAtEachEnd() {
        //ex [4,5] + [1,2,3,4,5] + [1,2] ===>>> [1,2,3,4,5]
        self.communityInfos = Array(communityInfos[2...(communityInfos.count-3)])
    }
}
