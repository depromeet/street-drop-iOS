//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 차요셉 on 8/12/24.
//

import UIKit
import Social

final class ShareViewController: SLComposeServiceViewController {
    
    
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }

}
