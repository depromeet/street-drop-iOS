//
//  NicknameEditViewModel.swift
//  StreetDrop
//
//  Created by JoongkyuPark on 2023/07/20.
//

import Foundation

import RxSwift
import RxRelay

final class NicknameEditViewModel: ViewModel {
    private let model = DefaultNicknameEditModel(
        repository: DefaultNicknameEditRepository(
            networkManager: NetworkManager()
        )
    )
}

extension NicknameEditViewModel {
    struct Input {
        let tapEditButtonEvent: Observable<String>
    }
    
    struct Output {
        var complete: PublishRelay<Void> = .init()
    }
}

extension NicknameEditViewModel {
    func convert(input: Input, disposedBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
            
        input.tapEditButtonEvent
            .subscribe(onNext: { [weak self] nickname in
                self?.editNickname(nickname: nickname, output: output, disposedBag: disposedBag)
            }).disposed(by: disposedBag)
        
        return output
    }
    
    func editNickname(nickname: String, output: Output, disposedBag: DisposeBag) {
        model.editNickname(nickname: nickname)
            .subscribe { _ in
                output.complete.accept(())
            }
            .disposed(by: disposedBag)
    }    
}
