//
//  MyInfoStorage.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/30.
//

import Foundation

protocol MyInfoStorage {
    func fetchMyInfo() -> MyInfo?
    func saveMyInfo(myInfo: MyInfo)
}
