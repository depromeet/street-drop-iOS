//
//  MusicApp.swift
//  StreetDrop
//
//  Created by 차요셉 on 2023/07/09.
//

import Foundation

enum MusicApp: String, CaseIterable, Codable {
    case youtubeMusic = "youtubemusic"
    case spotify = "spotify"
//    case appleMusic = "applemusic"
    
    var queryString: String {
        switch self {
        case .youtubeMusic:
            return "YOUTUBE_MUSIC"
        case .spotify:
            return "SPOTIFY"
//        case .appleMusic:
//            return "APPLE_MUSIC"
        }
    }
    
    var imageName: String {
        switch self {
        case .youtubeMusic:
            return "youtubeMusicLogo"
        case .spotify:
            return "spotifyLogo"
//        case .appleMusic:
//            return ""
        }
    }
    
    var text: String {
        switch self {
        case .youtubeMusic:
            return "Youtube music"
        case .spotify:
            return "Spotify"
//        case .appleMusic:
//            return "Apple music"
        }
    }
    
}
