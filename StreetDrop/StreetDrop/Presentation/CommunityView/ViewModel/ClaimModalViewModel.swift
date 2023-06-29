//
//  ClaimModalViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/27.
//

import Foundation

import RxSwift
import RxRelay

final class ClaimModalViewModel {
    struct Input {
        let tapClaimOption: Observable<Claim>
        let tapSendButton: Observable<Void>
    }

    struct Output {
        var claimStatusResults: PublishRelay<String> = .init()
    }

    private let itemID: Int
    private var claimOption: Claim?
    private let communityModel: CommunityModel

    init(itemID: Int,
         claimOption: Claim? = nil,
         communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.itemID = itemID
        self.claimOption = claimOption
        self.communityModel = communityModel
    }

    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()

        input.tapClaimOption
            .subscribe(onNext: { [weak self] in
                self?.claimOption = $0
            }).disposed(by: disposedBag)

        input.tapSendButton
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let claimOption = self.claimOption else { return }

                self.communityModel.claimComment(
                    itemID: self.itemID,
                    reason: claimOption.title
                )
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            // ✅ TODO: 토스트 문구 변경하기
                            print("\(response), 신고 성공 토스트 문구")
                            output.claimStatusResults.accept("신고 성공 토스트 문구")
                        } else if response == 409 {
                            print("\(response), 이미 신고했습니다. 토스트 문구")
                            output.claimStatusResults.accept("이미 신고했습니다. 토스트 문구")
                        } else {
                            output.claimStatusResults.accept("네트워크 확인 토스트 문구")
                        }
                    }, onFailure: { error in
                        output.claimStatusResults.accept("네트워크 확인 토스트 문구")
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

