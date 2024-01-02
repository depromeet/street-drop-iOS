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
        
        if let userActivity = connectionOptions.userActivities.filter({ $0.activityType == NSUserActivityTypeBrowsingWeb}).first {
            handleUniversialLink(isLaunched: true, userActivity: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleUniversialLink(isLaunched: false, userActivity: userActivity)
    }
}

private extension SceneDelegate {
    func handleUniversialLink(isLaunched: Bool, userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        else {
            return
        }
        
        guard let params = components.queryItems else { return }
        let items = parseLink(queryItem: params)
        
        guard components.path == "/music" else { return }
        
        if let itemIDValue = items["itemID"] as? String,
            let itemID = Int(itemIDValue) {
            print("itemID = \(itemID)")
            if isLaunched == false {
                navigateToCommunity(with: itemID)
            } else {
                UserDefaults.standard.set(itemID, forKey: UserDefaultKey.sharedMusicItemID)
            }
        } else {
            print("itemID missing")
        }
    }
    
    func parseLink(queryItem: [URLQueryItem]) -> [String: Any] {
        var queryData = [String: Any]()
        queryItem.forEach {
            if let value = $0.value {
                queryData[$0.name] = value
            }
        }
        
        return queryData
    }
    
    func navigateToCommunity(with itemID: Int) {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate
        
        if let navigationView = topViewController(base: sceneDelegate?.window!.rootViewController)?.navigationController as? UINavigationController{
            
            let communityViewModel = CommunityViewModel(
                communityInfos: [],
                index: 0
            )
            communityViewModel.itemID = itemID
            
            let communityView = CommunityViewController(viewModel: communityViewModel)
            navigationView.pushViewController(communityView, animated: true)
        }
    }
    
    func topViewController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
