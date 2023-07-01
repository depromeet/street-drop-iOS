//
//  OptionModalViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/01.
//

import Foundation

import RxSwift
import RxRelay


final class OptionModalViewModel {
    struct Input {
        let tapReviseOption: Observable<Void>
        let tapDeleteOption: Observable<Void>
    }

    struct Output {
        var musicIndex: PublishRelay<Int> = .init()
        var deleteStatusResults: PublishRelay<(isSuccess: Bool, toastTitle: String)> = .init()
    }

    private let itemID: Int
    private let musicIndex: Int
    private let communityModel: CommunityModel

    init(itemID: Int,
         musicIndex: Int,
         communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.itemID = itemID
        self.musicIndex = musicIndex
        self.communityModel = communityModel
    }

    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()

        input.tapReviseOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                output.musicIndex.accept(self.musicIndex)
            }).disposed(by: disposedBag)

        input.tapDeleteOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.communityModel.deleteMusic(itemID: self.itemID)
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            // ✅ TODO: 토스트 문구 변경하기
                            print("\(response), 삭제완료 토스트 문구")
                            output.deleteStatusResults.accept(
                                (isSuccess: true, toastTitle: "삭제완료 토스트 문구")
                            )
                        } else {
                            output.deleteStatusResults.accept(
                                (isSuccess: false, toastTitle: "네트워크 확인 토스트 문구")
                            )
                        }
                    }, onFailure: { error in
                        output.deleteStatusResults.accept(
                            (isSuccess: false, toastTitle: "네트워크 확인 토스트 문구")
                        )
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}
