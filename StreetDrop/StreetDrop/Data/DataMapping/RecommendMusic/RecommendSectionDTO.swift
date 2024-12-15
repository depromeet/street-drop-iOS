//
//  RecommendSectionDTO.swift
//  StreetDrop
//
//  Created by jihye kim on 14/12/2024.
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
        let basic: [MusicContentDTO]?
        let keyword: [KeywordContentDTO]?
    }

    struct MusicContentDTO: Decodable {
        let albumName: String
        let artistName: String
        let songName: String
        let durationTime: String
        let albumImage: String
        let albumThumbnailImage: String
        let genre: [String]
    }

    struct KeywordContentDTO: Decodable {
        let artistName: String
        let albumImage: String
        let albumThumbnailImage: String
    }
}
