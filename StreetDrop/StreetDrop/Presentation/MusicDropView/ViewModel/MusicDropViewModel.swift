
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
        let keyboardShowEvnet: Observable<Void>
        let keyboardHideEvnet: Observable<Void>
        let tapDropButton: Observable<Void>
        let comment: Observable<String>
    }

    struct Output {
        var locationTitle: PublishRelay<(address: String, text: String)> = .init()
        var musicTitle: PublishRelay<String> = .init()
        var artistTitle: PublishRelay<String> = .init()
        var albumImage: PublishRelay<Data> = .init()
        var isSuccessDrop: PublishRelay<Bool> = .init()
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

                self.outputLocationTitle(isKeyboardShow: false, output: output)

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

        input.keyboardShowEvnet
            .subscribe(onNext:  { [weak self] in
                self?.outputLocationTitle(isKeyboardShow: true, output: output)
            }).disposed(by: disposedBag)


        input.keyboardHideEvnet
            .subscribe(onNext:  { [weak self] in
                self?.outputLocationTitle(isKeyboardShow: false, output: output)
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
                            output.isSuccessDrop.accept(false)
                            return
                        }
                        output.isSuccessDrop.accept(true)
                    }, onFailure: { error in
                        output.errorDescription.accept("저장에 실패했습니다")
                        print(error.localizedDescription)
                        output.isSuccessDrop.accept(false)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

//MARK: - Private
private extension MusicDropViewModel {
    func outputLocationTitle(isKeyboardShow: Bool, output: Output) {
        // 주소(00동)
        let address = self.droppingInfo.location.address
        var locationTitle: (address: String, text: String) = (address: "", text: "")

        // 키보드 없을때와 있을때 라벨 내용 변경
        if !isKeyboardShow {
            locationTitle = address.isEmpty
            ? (address: "지금", text: "지금 위치에\n음악을 드랍할게요")
            : (address: address, text: "\(address) 위치에\n음악을 드랍할게요")
        } else if isKeyboardShow {
            locationTitle = address.isEmpty
            ? (address: "지금위치", text: "지금 위치")
            : (address: address, text: address)
        }

        output.locationTitle.accept(locationTitle)
    }
}
