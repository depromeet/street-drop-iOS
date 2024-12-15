//
//  RecommendMusicUsecase.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import RxSwift

protocol RecommendMusicUsecase {
    func getPromptOfTheDay() -> Single<String?>
    func getRecommendSections() -> Single<[RecommendSectionEntity]>
}

final class DefaultRecommendMusicUsecase: RecommendMusicUsecase {
    private let recommendMusicRepository: RecommendMusicRepository
    
    init(recommendMusicRepository: RecommendMusicRepository = DefaultRecommendMusicRepository()) {
        self.recommendMusicRepository = recommendMusicRepository
    }
    
    func getPromptOfTheDay() -> Single<String?> {
        recommendMusicRepository.fetchPromptOfTheDay()
    }
    
    func getRecommendSections() -> Single<[RecommendSectionEntity]> {
        recommendMusicRepository.fetchRecommendSectionList()
            .map { dtoList in
                dtoList.map { self.recommendSectionEntity(from: $0) }
            }
    }
}

// MARK: Conversion

extension DefaultRecommendMusicUsecase {
    private func recommendSectionEntity(from dto: RecommendSectionDTO) -> RecommendSectionEntity {
        typealias Entity = RecommendSectionEntity
        let convertedType = Entity.ContentType(rawValue: dto.type.rawValue) ?? .basic

        let convertedContent: Entity.Content
        switch convertedType {
        case .basic:
            let basicContent = dto.content.basic?.map {
                Entity.MusicContentEntity(
                    albumName: $0.albumName,
                    artistName: $0.artistName,
                    songName: $0.songName,
                    durationTime: $0.durationTime,
                    albumImage: $0.albumImage,
                    albumThumbnailImage: $0.albumThumbnailImage,
                    genre: $0.genre
                )
            }
            convertedContent = Entity.Content(basic: basicContent)
        case .keyword:
            let keywordContent = dto.content.keyword?.map {
                RecommendSectionEntity.KeywordContentEntity(
                    artistName: $0.artistName,
                    albumImage: $0.albumImage,
                    albumThumbnailImage: $0.albumThumbnailImage
                )
            }
            convertedContent = Entity.Content(keyword: keywordContent)
        }

        return Entity(
            title: dto.title,
            description: dto.description,
            type: convertedType,
            content: convertedContent
        )
    }
}
