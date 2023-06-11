//
//  ResponseSampleData.swift
//  StreetDrop
//
//  Created by 맹선아 on 2023/06/11.
//

import Foundation

enum ResponseSampleData {
    static let searchMusicSampleData = Data("""
                        {
                            "data": [
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    },
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    },
                                    {
                                        "albumName": "Dynamite (DayTime Version) - EP",
                                        "artistName": "방탄소년단",
                                        "songName": "Dynamite",
                                        "durationTime": "3:20",
                                        "albumImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/300x300bb.jpg",
                                        "albumThumbnailImage": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/100x100bb.jpg",
                                        "genre": [
                                            "Rock",
                                            "K-pop"
                                        ]
                                    }
                                ]
                        }
                        """.utf8)

    static let fetchNumberOfDroppedMusicByDongSampleData = Data("""
                        {
                            "numberOfDroppedMusic": 247
                        }
                        """.utf8)

    static let getPOISampleData = Data("""
                        {
                            "poi": [
                            {
                                "itemId": 1,
                                "albumThumbnailImage" : "http://img.com",
                                "latitude": 89.33,
                                "longitude": 123.222
                            },
                            {
                                "itemId": 2,
                                "albumThumbnailImage" : "http://img.com",
                                "latitude": 88.214,
                                "longitude": 122.908
                            }
                            ]
                        }
                        """.utf8)

}
