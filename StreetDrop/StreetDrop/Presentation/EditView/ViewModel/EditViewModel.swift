//
//  EditViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/02.
//

import Foundation

// 드랍뷰모델 재사용 (상속)

final class EditViewModel: MusicDropViewModel {

    let editInfo: EditInfo

    init (editInfo: EditInfo) {
        self.editInfo = editInfo

        let droppingInfo = DroppingInfo(
            location: DroppingInfo.Location(latitude: 0, longitude: 0, address: ""),
            music: Music(
                albumName: "",
                artistName: editInfo.artist,
                songName: editInfo.musicTitle,
                durationTime: "",
                albumImage: editInfo.albumImageURL,
                albumThumbnailImage: "",
                genre: [])
        )

        super.init(droppingInfo: droppingInfo)
        self.state = .edit
    }

    func convert(input: Input, disposedBag: DisposeBag) -> Output {
    }
}
