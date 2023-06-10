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
    }

    struct Output {
        var addressTitle: PublishRelay<String> = .init()
        var albumImages: PublishRelay<[String]> = .init()
        var musicTitle: PublishRelay<String> = .init()
        var artistTitle: PublishRelay<String> = .init()
        var genresText: PublishRelay<[String]> = .init()
        var commentText: PublishRelay<String> = .init()
        var profileImage: PublishRelay<Data> = .init()
        var nicknameText: PublishRelay<String> = .init()
        var dateText: PublishRelay<String> = .init()
        var errorDescription: BehaviorRelay<String?> = .init(value: nil)
    }

    private var communityInfos: [CommunityInfo]
    private var currentIndex: Int
    private let disposeBag: DisposeBag = DisposeBag()

    var communityInfoCount: Int {
        return communityInfos.count
    }
    
    init(communityInfos: [CommunityInfo], index: Int) {
        self.communityInfos = communityInfos
        self.currentIndex = index

        prepareInfiniteCarousel()
    }

    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                output.addressTitle.accept(self.communityInfos[self.currentIndex].adress)
                output.albumImages.accept(self.communityInfos.map {$0.music.albumImage} )
                self.changeCommunityInfoForIndex(index: self.currentIndex, output: output)
            }).disposed(by: disposedBag)

        input.changedIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.changeCommunityInfoForIndex(index: index, output: output)
            }).disposed(by: disposedBag)

        return output
    }

    private func changeCommunityInfoForIndex(index: Int, output: Output) {
        let communityInfo = communityInfos[index]

        output.musicTitle.accept(communityInfo.music.title)
        output.artistTitle.accept(communityInfo.music.artist)
        output.genresText.accept(communityInfo.music.genre)
        output.commentText.accept(communityInfo.comment)
        output.nicknameText.accept(communityInfo.user.nickname)
        output.dateText.accept(communityInfo.dropDate)

        fetchImage(url: communityInfo.user.profileImage, output: output)
            .subscribe(onNext: { data in
                output.profileImage.accept(data)
            }).disposed(by: disposeBag)
    }

    func fetchImage(url: String, output: Output) -> Observable<Data> {
        return Observable.create { observer in
            DispatchQueue.global().async {
                do {
                    if let albumImageUrl = URL(string: url) {
                        let imageData = try Data(contentsOf: albumImageUrl)
                        observer.onNext(imageData)
                    }
                } catch {
                    output.errorDescription.accept("Image 불러오기에 실패했습니다")
                }
            }
            
            return Disposables.create()
        }
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
        currentIndex += 2
    }

    private func convertDateFormat(date: String) -> String {
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
