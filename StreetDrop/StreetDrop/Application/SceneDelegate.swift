//
//  SceneDelegate.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        else {
            return
        }
        
        let path = components.path
        guard let params = components.queryItems else { return }
        
        print("path = \(path)")
        print("params = \(params)")
        
        if let itemID = params.first(where: { $0.name == "itemID"})?.value {
            print("itemID = \(itemID)")
        } else {
            print("itemID missing")
        }
    }
}
