//
//  SceneDelegate.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()

        let music1 = CommunityInfo.Music.init(
            title: "하입보이",
            artist: "New jeans",
            albumImage: "https://www.youtube.com/watch?v=YGieI3KoeZk",
            genre: ["kPOP", "TestGenre"]
        )

        let music2 = CommunityInfo.Music.init(
            title: "하입보이22222",
            artist: "New jeans22222",
            albumImage: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/03/8d/0e/038d0e52-e96d-f386-b8eb-9f77fa013543/195497146918_Cover.jpg/50x50bb.jpg",
            genre: ["kPOP", "TestGenre", "또뭐다냐"]
        )

        let user1 = CommunityInfo.User.init(nickname: "일",
                                            profileImage: "https://s3.orbi.kr/data/file/united/35546557a06831597f6e7851cb6c86e9.jpg",
                                            musicApp: "youtubemusic"
        )

        let user2 = CommunityInfo.User.init(nickname: "일이삼사오육칠팔구십일이",
                                            profileImage: "https://s3.orbi.kr/data/file/united/35546557a06831597f6e7851cb6c86e9.jpg",
                                            musicApp: "youtubemusic"
        )

        let community1 = CommunityInfo(adress: "서울시 강남구 강남동",
                                       music: music1,
                                       comment: "TESTTESTTESTTEST",
                                       user: user1,
                                       dropDate: "2023-05-26 01:13:14"
        )

        let community2 = CommunityInfo(adress: "수원시 원천동",
                                       music: music2,
                                       comment: "테스트더미 만들기귀찮아 죽것다아아\n두번째줄\n세번째줄\n네번째줄",
                                       user: user2,
                                       dropDate: "2023-05-21 01:13:14"
        )

        let navigationController = UINavigationController(
            rootViewController: CommunityViewController(
                viewModel: CommunityViewModel(
                    communityInfos: [community1, community2, community1, community2],
                    index: 0
                )
            )
        )

        navigationController.navigationBar.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
