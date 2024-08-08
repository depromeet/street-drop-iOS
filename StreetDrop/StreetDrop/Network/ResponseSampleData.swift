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
    
    static let getPopUpInfomationSampleData = Data("""
                        {
                        "data": [
                            {
                                "type" : "guide",
                                "content": {
                                    "id": 1,
                                    "title": "더 많은 음악을 듣고 싶다면?",
                                    "popupName": "GUIDE_1",
                                    "description": "레벨업하면 음악을 들을 수 있는 반경이 200M 더 넓어져요"
                                }
                            },
                            {
                                "type" : "levelUp",
                                "content": {
                                    "id": 1,
                                    "title": "축하합니다!\\n프로드랍퍼가 되었어요",
                                    "popupName": "LEVEL_2",
                                    "description": "프로드랍퍼는 전보다\\n200M 넓게 음악을 들을 수 있어요",
                                    "remainCount": 12
                                }
                            }
                        ]
                        }
                        """.utf8)
    static let getRegionFilteredDropCountSampleData = Data("""
                        {
                        "numberOfDroppedItem": 17
                        }
                        """.utf8)
}
