//
//  SettingsViewModel.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/06/13.
//

import Foundation

import RxSwift
import RxRelay

protocol SettingsViewModel: ViewModel {
    
}

final class DefaultSettingsViewModel: SettingsViewModel {
    private let useCase: SettingsUseCase
    
    init(useCase: SettingsUseCase = DefaultSettingsUseCase()) {
        self.useCase = useCase
    }
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let musicAppButtonEvent: Observable<String>
    }
    
    struct Output {
        let defaultSettingSectionTypes: PublishRelay<[SettingSectionType]> = .init()
        let currentMusicApp: PublishRelay<MusicApp> = .init()
        let savedMusicAppInServer: PublishRelay<MusicApp> = .init()
        let changingMusicAppFailAlert: PublishRelay<String> = .init()
        let hasNewNotice: PublishRelay<Bool> = .init()
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] in
                self?.fetchSettingSectionTypes(output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.musicAppButtonEvent
            .bind(onNext: { [weak self] musicAppQueryString in
                self?.selectMusicApp(
                    musicAppQueryString: musicAppQueryString,
                    output: output,
                    disposeBag: disposedBag
                )
            })
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension DefaultSettingsViewModel {
    func selectMusicApp(musicAppQueryString: String, output: Output, disposeBag: DisposeBag) {
        self.useCase.updateUsersMusicApp(musicAppQueryString: musicAppQueryString)
            .subscribe { savedMusicAppInServer in
                output.savedMusicAppInServer.accept(savedMusicAppInServer)
            } onFailure: { error in
                output.changingMusicAppFailAlert.accept("연결 앱 변경이 실패했어요!")
            }
            .disposed(by: disposeBag)
    }
}

private extension DefaultSettingsViewModel {
    func fetchSettingSectionTypes(output: Output, disposeBag: DisposeBag) {
        Observable.zip(
            fetchDefaultSettingSectionTypes(),
            checkHasNewNotice(),
            fetchMyMusicApp(output: output)
        )
        .map { settingSectionTypes, hasNewNotice, myMusicApp in
            self.updateSettingSectionTypes(
                settingSectionTypes,
                hasNewNotice: hasNewNotice,
                myMusicApp: myMusicApp
            )
        }
        .subscribe(onNext: { updatedSettingSectionTypes in
            output.defaultSettingSectionTypes.accept(updatedSettingSectionTypes)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchDefaultSettingSectionTypes() -> Observable<[SettingSectionType]> {
        Observable.create { observer in
            let settingSectionTypes = self.useCase.fetchDefaultSettingSectionTypes()
            observer.onNext(settingSectionTypes)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func checkHasNewNotice() -> Observable<Bool> {
        self.useCase.fetchLastSeenNoticeId()
            .flatMap { [weak self] noticeId -> Single<Bool> in
                guard let self else { return Single.just(false) }
                return self.useCase.checkNewNotice(lastNoticeId: noticeId)
            }
            .asObservable()
    }
    
    func fetchMyMusicApp(output: Output) -> Observable<MusicApp> {
        self.useCase.fetchMyMusicApp()
            .asObservable()
            .do(onError: { error in
                output.changingMusicAppFailAlert.accept("연결 앱 변경이 실패했어요!")
            })
    }
    
    func updateSettingSectionTypes(
        _ settingSectionTypes: [SettingSectionType],
        hasNewNotice: Bool,
        myMusicApp: MusicApp
    ) -> [SettingSectionType] {
        return settingSectionTypes.map { sectionType -> SettingSectionType in
            // myMusicApp
            if sectionType.section == .appSettings {
                let updatedItems = sectionType.items.map { item -> SettingItem in
                    if case .musicApp = item {
                        return .musicApp(myMusicApp)
                    }
                    return item
                }
                return SettingSectionType(section: sectionType.section, items: updatedItems)
            }
            
            // notice
            if sectionType.section == .servicePolicies {
                let updatedItems = sectionType.items.map { item -> SettingItem in
                    if case .notice = item {
                        return .notice(hasNewNotice)
                    }
                    return item
                }
                return SettingSectionType(section: sectionType.section, items: updatedItems)
            }
            
            return sectionType
        }
    }
}
