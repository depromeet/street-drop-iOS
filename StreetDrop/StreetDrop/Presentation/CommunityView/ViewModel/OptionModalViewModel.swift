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
        let tapReviseOption: Observable<Void>
        let tapDeleteOption: Observable<Void>
    }

    struct Output {
        // 없음
    }

    private let itemID: Int
    private let musicIndex: Int
    private let communityModel: CommunityModel
    var delegate: OptionModalViewModelDelegate?

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

                // 수정 액션
            }).disposed(by: disposedBag)

        input.tapDeleteOption
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.communityModel.deleteMusic(itemID: self.itemID)
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            self.deleteMusic(isSuccess: true)
                        } else {
                            self.deleteMusic(isSuccess: false)
                        }
                    }, onFailure: { error in
                        self.deleteMusic(isSuccess: false)
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

//MARK: - Private
private extension OptionModalViewModel {
    func deleteMusic(isSuccess: Bool) {
        // ✅ TODO: 토스트 문구 변경하기
        let toastTitle: String = isSuccess ? "삭제완료 토스트 문구" : "네트워크 확인 토스트 문구"
        delegate?.deleteMusic(isSuccess, toastTitle: toastTitle, musicIndex: self.musicIndex)
    }
}
