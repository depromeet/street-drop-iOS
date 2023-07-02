//
//  EditViewModel.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/07/02.
//

import Foundation

import RxSwift
import RxRelay

protocol EditViewModelDelegate {
    func editComment(editedComment: String, musicIndex: Int)
}

// 드랍뷰모델 재사용 (상속)
final class EditViewModel: MusicDropViewModel {

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let tapEditButtonEvent: Observable<String>
    }

    struct Output {
        var comment: PublishRelay<String> = .init()
        let dismiss: PublishRelay<Void> = .init()
    }

    private let editInfo: EditInfo
    private let editModel: EditModel
    private let musicIndex: Int
    var delegate: EditViewModelDelegate?

    init (editInfo: EditInfo, musicIndex: Int, editModel: EditModel = EditModel()) {
        self.editInfo = editInfo
        self.musicIndex = musicIndex
        self.editModel = editModel

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
        let output = Output()

        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                output.comment.accept(self.editInfo.content)
            }).disposed(by: disposedBag)

        input.tapEditButtonEvent
            .subscribe(onNext: { [weak self] editedComment in
                guard let self = self,
                      self.state == .edit else { return }

                self.editModel.edit(itemId: self.editInfo.id, content: editedComment)
                    .subscribe(onSuccess: { response in
                        if !(200...299).contains(response) {
                            //TODO: - 실패 토스트 띄워주기
                            return
                        }
                        
                        self.delegate?.editComment(
                            editedComment: editedComment,
                            musicIndex: self.musicIndex
                        )

                        output.dismiss.accept(())
                    }, onFailure: { error in
                        //TODO: - 실패 토스트 띄워주기
                        print(error.localizedDescription)
                    }).disposed(by: disposedBag)
            }).disposed(by: disposedBag)

        return output
    }
}
