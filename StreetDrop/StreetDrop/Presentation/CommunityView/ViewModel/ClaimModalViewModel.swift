//
//  ClaimModalViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/27.
//

import Foundation

import RxSwift
import RxRelay

protocol ClaimModalViewModelDelegate {
    func showToast(state: ToastView.State, text: String)
}

final class ClaimModalViewModel {
    struct Input {
        let tapClaimOption: Observable<Claim>
        let tapSendButton: Observable<Void>
    }

    struct Output {
        var dismiss: PublishRelay<Void> = .init()
    }

    private let itemID: Int
    private var claimOption: Claim?
    private let claimingCommentUseCase: ClaimingCommentUseCase
    var delegate: ClaimModalViewModelDelegate?

    init(itemID: Int,
         claimOption: Claim? = nil,
         claimingCommentUseCase: ClaimingCommentUseCase = DefaultClaimingCommentUseCase()
    ) {
        self.itemID = itemID
        self.claimOption = claimOption
        self.claimingCommentUseCase = claimingCommentUseCase
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
                      let claimOption = self.claimOption,
                      let delegate = self.delegate else { return }
                claimingCommentUseCase.execute(
                    itemID: self.itemID,
                    reason: claimOption.title
                )
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            delegate.showToast(state: .success, text: "정상적으로 신고가 접수되었습니다")
                        } else if response == 409 {
                            delegate.showToast(state: .success, text: "이미 신고한 게시글입니다")
                        } else {
                            delegate.showToast(state: .fail, text: "네트워크를 확인해주세요")
                        }
                        output.dismiss.accept(())
                    }, onFailure: { error in
                        delegate.showToast(state: .fail, text: "네트워크를 확인해주세요")
                        output.dismiss.accept(())
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

