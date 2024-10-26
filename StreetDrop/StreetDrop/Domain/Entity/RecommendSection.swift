//
//  RecommendSection.swift
//  StreetDrop
//
//  Created by jihye kim on 26/10/2024.
//

struct RecommendSectionResponse: Decodable {
    let data: [RecommendSectionDTO]
}

struct PromptOfTheDayResponse: Decodable {
    let sentence: String?
}

struct RecommendSectionDTO: Decodable {
    // Header
    let title: String
    let description: String?

    // Content
    let type: ContentType
    let content: Content

    enum ContentType: String, Decodable {
        case basic
        case keyword

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = ContentType(rawValue: rawValue.lowercased()) ?? .basic
        }
    }

    struct Content: Decodable {
        let basic: [MusicContent]?
        let keyword: [KeywordContent]?
    }

    struct MusicContent: Decodable {
        let albumName: String
        let artistName: String
        let songName: String
        let durationTime: String
        let albumImage: String
        let albumThumbnailImage: String
        let genre: [String]
    }

    struct KeywordContent: Decodable {
        let artistName: String
        let albumImage: String
        let albumThumbnailImage: String
    }
}

// MARK: Conversion

extension RecommendSectionDTO {
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
