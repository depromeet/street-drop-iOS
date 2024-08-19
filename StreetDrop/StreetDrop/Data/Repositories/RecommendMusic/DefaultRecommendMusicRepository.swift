//
//  DefaultRecommendMusicRepository.swift
//  StreetDrop
//
//  Created by jihye kim on 07/08/2024.
//

import Foundation

import Moya
import RxSwift

final class DefaultRecommendMusicRepository: RecommendMusicRepository {
    private let networkManager: NetworkManager
    
    init(
        networkManager: NetworkManager = NetworkManager(
            provider: MoyaProvider<MultiTarget>()
        )
    ) {
        self.networkManager = networkManager
    }
    
    // TODO: jihye - update api
    
    func fetchPromptOfTheDay() -> Single<String> {
        Single.just("비오는 날, 어떤 음악이 떠오르시나요?")
    }
    
    func fetchTrendingMusicList() -> Single<[Music]> {
        Single.just([
            Music(
                albumName: "",
                artistName: "ILLIT",
                songName: "Magnetic",
                durationTime: "2:41",
                albumImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                albumThumbnailImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                genre: []
            )
        ])
    }
    
    func fetchMostDroppedMusicList() -> Single<[Music]> {
        Single.just([
            Music(
                albumName: "",
                artistName: "NewJeans",
                songName: "Supernatural",
                durationTime: "3:11",
                albumImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                albumThumbnailImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                genre: []
            )
        ])
    }
    
    func fetchArtistList() -> Single<[Artist]> {
        return Single.just([
            Artist(name: "NewJeans", image: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg"),
            Artist(name: "SEVENTEEN", image: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg"),
            Artist(name: "아이유", image: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg"),
            Artist(name: "aespa", image: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg"),
            Artist(name: "최유리", image: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg")
        ])
    }
}
