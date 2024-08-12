//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/12/24.
//

import UIKit
import Social

import RxSwift

final class ShareViewController: SLComposeServiceViewController {
    private let viewModel: ShareViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension ShareViewController {
    func bindViewModel() {
        let input: ShareViewModel.Input = .init(viewDidLoadEvent: .just(Void()))
        let output: ShareViewModel.Output = viewModel.convert(
            input: input,
            disposedBag: disposeBag
        )
    }
    
    
}
