//
//  RecommendSection.swift
//  StreetDrop
//
//  Created by jihye kim on 26/10/2024.
//

struct RecommendSectionEntity {
    // Header
    let title: String
    let description: String?

    // Content
    let type: ContentType
    let content: Content

    enum ContentType: String {
        case basic
        case keyword
    }

    struct Content {
        var basic: [MusicContentEntity]?
        var keyword: [KeywordContentEntity]?
    }

    struct MusicContentEntity {
        let albumName: String
        let artistName: String
        let songName: String
        let durationTime: String
        let albumImage: String
        let albumThumbnailImage: String
        let genre: [String]
    }

    struct KeywordContentEntity {
        let artistName: String
        let albumImage: String
        let albumThumbnailImage: String
    }
}

// MARK: Conversion

extension RecommendSectionEntity {
    typealias HeaderInfo = RecommendMusicSectionModel.Header
    typealias Item = RecommendMusicSectionModel.Item

    var sectionModel: RecommendMusicSectionModel? {
        switch type {
        case .basic:
            guard let basic = content.basic else { return nil }
            let musicList = basic.map { basicContent in
                Music(
                    albumName: basicContent.albumName,
                    artistName: basicContent.artistName,
                    songName: basicContent.songName,
                    durationTime: basicContent.durationTime,
                    albumImage: basicContent.albumImage,
                    albumThumbnailImage: basicContent.albumThumbnailImage,
                    genre: basicContent.genre
                )
            }
            return .init(
                type: .basic(.init(title: title, info: description), musicList),
                items: musicList.map { Item.basic($0) }
            )
        case .keyword:
            guard let keyword = content.keyword else { return nil }
            return .init(
                type: .keyword(.init(title: title, info: description)),
                items: keyword.map { keywordContent in
                    Item.keyword(
                        .init(
                            text: keywordContent.artistName,
                            image: keywordContent.albumThumbnailImage
                        )
                    )
                }
            )
        }
    }
}

struct SearchKeywordEntity: Hashable {
    let text: String
    let image: String
}
