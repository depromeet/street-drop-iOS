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
    private let model: SettingsModel
    
    init(model: SettingsModel = DefaultSettingsModel()) {
        self.model = model
    }
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let musicAppButtonEvent: Observable<String>
    }
    
    struct Output {
        let currentMusicApp: PublishRelay<MusicApp> = .init()
        let savedMusicAppInServer: PublishRelay<MusicApp> = .init()
        let changingMusicAppFailAlert: PublishRelay<String> = .init()
    }
    
    func convert(input: Input, disposedBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .bind { [weak self] in
                self?.fetchMymusicAppFromLocal(output: output, disposeBag: disposedBag)
            }
            .disposed(by: disposedBag)
        
        input.musicAppButtonEvent
            .bind(onNext: { [weak self] musicAppQueryString in
                self?.selectMusicApp(musicAppQueryString: musicAppQueryString, output: output, disposeBag: disposedBag)
            })
            .disposed(by: disposedBag)
        
        return output
    }
}

private extension DefaultSettingsViewModel {
    func selectMusicApp(musicAppQueryString: String, output: Output, disposeBag: DisposeBag) {
        self.model.updateUsersMusicAppToServer(musicAppQueryString: musicAppQueryString)
            .subscribe { savedMusicAppInServer in
                output.savedMusicAppInServer.accept(savedMusicAppInServer)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchMymusicAppFromLocal(output: Output, disposeBag: DisposeBag) {
        self.model.fetchMymusicAppFromLocal()
            .subscribe { myMusicApp in
                output.currentMusicApp.accept(myMusicApp)
            } onFailure: { error in
                output.changingMusicAppFailAlert.accept("연결 앱 변경이 실패했어요!")
            }
            .disposed(by: disposeBag)
    }
}
