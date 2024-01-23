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
        
        checkInitLinks(connectionOptions: connectionOptions)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleUniversialLink(isLaunched: false, userActivity: userActivity)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(isLaunched: false, url: url)
    }
}

// MARK: - Private Methods

private extension SceneDelegate {
    func checkInitLinks(connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions
            .userActivities
            .filter({ $0.activityType == NSUserActivityTypeBrowsingWeb})
            .first {
            handleUniversialLink(isLaunched: true, userActivity: userActivity)
        }
        
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(isLaunched: true, url: url)
        }
    }
    
    func handleUniversialLink(isLaunched: Bool, userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        else {
            return
        }
        
        guard components.path == "/music" else { return }
        handlingSharedMusic(isLaunched: isLaunched, components: components)
    }
    
    func handleDeepLink(isLaunched: Bool, url: URL) {
        if url.scheme == "streetdrop" {
            if url.host == "music" {
                guard let components = URLComponents(string: url.absoluteString) else { return }
                handlingSharedMusic(isLaunched: isLaunched, components: components)
            }
        }
    }
    
    func handlingSharedMusic(isLaunched: Bool, components: URLComponents) {
        guard let query = components.query,
              let decodedParams = query.fromBase64SafeURL()
        else { return }
        
        print(decodedParams)
        let items = decodedParams.split(separator: "=")
        guard items.count > 1 else { return }
        
        if items.first == "itemID" {
            if let itemID = Int(items[1]) {
                if isLaunched == false {
                    navigateToCommunity(with: itemID)
                } else {
                    UserDefaults.standard.set(itemID, forKey: UserDefaultKey.sharedMusicItemID)
                }
            } else {
                print("itemID missing")
            }
        }
    }
    
    func navigateToCommunity(with itemID: Int) {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as? SceneDelegate
        
        if let navigationView = topViewController(base: sceneDelegate?.window!.rootViewController)?
            .navigationController as? UINavigationController{
            
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
