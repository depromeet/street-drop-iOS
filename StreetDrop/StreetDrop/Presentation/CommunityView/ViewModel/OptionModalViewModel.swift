//
//  OptionModalViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/01.
//

import Foundation

import RxSwift
import RxRelay

protocol OptionModalViewModelDelegate {
    func deleteMusic(_ isSuccess: Bool, toastTitle: String, musicIndex: Int)
}

final class OptionModalViewModel {
    struct Input {
        let tapEditOption: Observable<Void>
        let tapDeleteOption: Observable<Void>
    }

    struct Output {
        let dismiss: PublishRelay<Void> = .init()
    }

    let communityInfo: MusicWithinAreaEntity
    private let musicIndex: Int
    private let communityModel: CommunityModel
    var delegate: OptionModalViewModelDelegate?

    init(communityInfo: MusicWithinAreaEntity,
         musicIndex: Int,
         communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.communityInfo = communityInfo
        self.musicIndex = musicIndex
        self.communityModel = communityModel
    }

    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()

        input.tapDeleteOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.communityModel.deleteMusic(itemID: self.communityInfo.id)
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            self.deleteMusic(isSuccess: true, output: output)
                        } else {
                            self.deleteMusic(isSuccess: false, output: output)
                        }
                    }, onFailure: { error in
                        self.deleteMusic(isSuccess: false, output: output)
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

//MARK: - Private
private extension OptionModalViewModel {
    func deleteMusic(isSuccess: Bool, output: Output) {
        // ✅ TODO: 토스트 문구 변경하기
        output.dismiss.accept(())
        let toastTitle: String = isSuccess ? "삭제완료 토스트 문구" : "네트워크 확인 토스트 문구"
        delegate?.deleteMusic(isSuccess, toastTitle: toastTitle, musicIndex: self.musicIndex)
    }
}
