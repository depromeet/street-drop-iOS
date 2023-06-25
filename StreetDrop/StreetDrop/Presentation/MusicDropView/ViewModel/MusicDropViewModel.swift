
//
//  MusicDropViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/05/21.
//

import Foundation

import RxSwift
import RxRelay

final class MusicDropViewModel: ViewModel {

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let tapDropButton: Observable<Void>
        let comment: Observable<String>
    }

    struct Output {
        var locationTitle: PublishRelay<(address: String, text: String)> = .init()
        var musicTitle: PublishRelay<String> = .init()
        var artistTitle: PublishRelay<String> = .init()
        var albumImage: PublishRelay<Data> = .init()
        let errorDescription: BehaviorRelay<String?> = .init(value: nil)
    }

    private let droppingInfo: DroppingInfo
    private let musicDropModel: MusicDropModel
    private let disposeBag: DisposeBag = DisposeBag()

    init (
        droppingInfo: DroppingInfo,
        musicDropModel: MusicDropModel = MusicDropModel()
    ) {
        self.droppingInfo = droppingInfo
        self.musicDropModel = musicDropModel
    }

    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                // 주소(00동)
                let address = self.droppingInfo.location.address
                if !address.isEmpty {
                    output.locationTitle.accept(
                        (address: address, text: "'\(address)' 위치에\n음악을 드랍할게요")
                    )
                } else {
                    output.locationTitle.accept(
                        (address: "지금", text: "'지금' 위치에\n음악을 드랍할게요")
                    )
                }

                // 앨범 커버
                if let albumImageUrl = URL(string: self.droppingInfo.music.albumImage) {
                    DispatchQueue.global().async {
                        do {
                            output.albumImage.accept(try Data(contentsOf: albumImageUrl))
                        } catch {
                            output.errorDescription.accept("albumImage 불러오기에 실패했습니다")
                        }
                    }
                }

                //음악제목, 가수이름
                output.musicTitle.accept(self.droppingInfo.music.songName)
                output.artistTitle.accept(self.droppingInfo.music.artistName)
            }).disposed(by: disposedBag)

        input.tapDropButton
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                var comment = ""
                input.comment.bind { comment = $0 }.disposed(by: DisposeBag())

                self.musicDropModel.drop(droppingInfo: self.droppingInfo, content: comment)
                    .subscribe(onSuccess: { response in
                        if !(200...299).contains(response) {
                            output.errorDescription.accept("저장에 실패했습니다")
                        }
                    }, onFailure: { error in
                        output.errorDescription.accept("저장에 실패했습니다")
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}
