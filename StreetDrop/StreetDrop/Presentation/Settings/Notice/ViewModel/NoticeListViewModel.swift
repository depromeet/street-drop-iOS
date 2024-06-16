//
//  NoticeListViewModel.swift
//  StreetDrop
//
//  Created by jihye kim on 16/06/2024.
//

import Foundation

import RxRelay
import RxSwift

protocol NoticeListViewModel: ViewModel { }

final class DefaultNoticeListViewModel: NoticeListViewModel {
    private let useCase: NoticeUseCase
    private let dateManager: DateManager
    
    init(
        useCase: NoticeUseCase = DefaultNoticeUseCase(),
        dateManager: DateManager = DefaultDateManager()
    ) {
        self.useCase = useCase
        self.dateManager = dateManager
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let noticeList: PublishRelay<[Notice]> = .init()
        let noticeListFailAlert: PublishRelay<String> = .init()
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] in
                self?.fetchNoticeList(output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension DefaultNoticeListViewModel {
    func fetchNoticeList(output: Output, disposeBag: DisposeBag) {
        self.useCase.fetchNoticeList()
            .subscribe { [weak self] noticeList in
                guard let self else { return }
                output.noticeList.accept(noticeList.map { self.convertToNotice($0) })
            } onFailure: { error in
                // TODO: jihye - 에러처리
            }
            .disposed(by: disposeBag)
    }
    
    private func convertToNotice(_ notice: NoticeEntity) -> Notice {
        .init(
            announcementId: notice.announcementId,
            title: notice.title,
            createdAt: dateManager.convertToformattedString(notice.createdAt)
        )
    }
}

