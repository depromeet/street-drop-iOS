//
//  NoticeDetailViewModel.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import RxRelay
import RxSwift

protocol NoticeDetailViewModel: ViewModel { }

final class DefaultNoticeDetailViewModel: NoticeDetailViewModel {
    private let noticeId: Int
    private let useCase: NoticeUseCase
    private let dateManager: DateManager
    
    init(
        noticeId: Int,
        useCase: NoticeUseCase = DefaultNoticeUseCase(),
        dateManager: DateManager = DefaultDateManager()
    ) {
        self.noticeId = noticeId
        self.useCase = useCase
        self.dateManager = dateManager
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let noticeDetail: PublishRelay<NoticeDetail> = .init()
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] in
                guard let self else { return }
                self.fetchNoticeDetail(id: self.noticeId, output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension DefaultNoticeDetailViewModel {
    func fetchNoticeDetail(id: Int, output: Output, disposeBag: DisposeBag) {
        self.useCase.fetchNoticeDetail(id: id)
            .subscribe { [weak self] noticeDetail in
                guard let self else { return }
                output.noticeDetail.accept(self.convertToNoticeDetail(noticeDetail))
            } onFailure: { error in
                // TODO: jihye - 에러처리
            }
            .disposed(by: disposeBag)
    }
    
    private func convertToNoticeDetail(_ noticeDetail: NoticeDetailEntity) -> NoticeDetail {
        .init(
            announcementId: noticeDetail.announcementId,
            title: noticeDetail.title,
            content: noticeDetail.content,
            createdAt: dateManager.convertToformattedString(noticeDetail.createdAt)
        )
    }
}
