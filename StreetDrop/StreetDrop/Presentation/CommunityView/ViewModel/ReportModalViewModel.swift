//
//  ReportModalViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/27.
//

import Foundation

import RxSwift
import RxRelay

final class ReportModalViewModel {
    struct Input {
        let tapReportOption: Observable<Report>
        let tapSendButton: Observable<Void>
    }

    struct Output {
        var reportStatusResults: PublishRelay<String> = .init()
    }

    private let itemID: Int
    private var reportOption: Report?
    private let communityModel: CommunityModel

    init(itemID: Int,
         reportOption: Report? = nil,
         communityModel: CommunityModel = DefaultCommunityModel()
    ) {
        self.itemID = itemID
        self.reportOption = reportOption
        self.communityModel = communityModel
    }

    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()

        input.tapReportOption
            .subscribe(onNext: { [weak self] in
                self?.reportOption = $0
            }).disposed(by: disposedBag)

        input.tapSendButton
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let reportOption = self.reportOption else { return }

                self.communityModel.claimComment(
                    itemID: self.itemID,
                    reason: reportOption.title
                )
                    .subscribe(onSuccess: { response in
                        if (200...299).contains(response) {
                            // ✅ TODO: 토스트 문구 변경하기
                            output.reportStatusResults.accept("신고 성공 토스트 문구")
                        } else if response == 409 {
                            output.reportStatusResults.accept("이미 신고했습니다. 토스트 문구")
                        } else {
                            output.reportStatusResults.accept("네트워크 확인 토스트 문구")
                        }
                    }, onFailure: { error in
                        output.reportStatusResults.accept("네트워크 확인 토스트 문구")
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}

