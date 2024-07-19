//
//  MusicListTableView.swift
//  StreetDrop
//
//  Created by thoonk on 7/12/24.
//

import UIKit

final class MusicListTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
