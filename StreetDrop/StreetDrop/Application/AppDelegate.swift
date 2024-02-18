//
//  AppDelegate.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging
import GoogleMobileAds
import NMapsMap
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let fcmRepository: FCMRepository = DefaultFCMRepository()
    private let disposedBag: DisposeBag = .init()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        NMFAuthManager.shared().clientId = Bundle.main.naverMapsClientID
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            granted ? print("알림 등록이 완료되었습니다.") : Void()
        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        return [[.banner, .list, .sound] ]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        guard fcmToken == UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken) ?? "" else {
            //TODO: 푸시 등록 API 추가
            fcmRepository.enrollFCMToken(token: fcmToken)
                .subscribe(onSuccess: { response in
                    if (200...299).contains(response) {
                        print("fcm token 서버 등록 성공")
                        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKey.fcmToken)
                    } else {
                        print("fcm token 서버 등록 실패 statusCode: \(response)")
                    }
                }, onFailure: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: disposedBag)
            return
        }
    }
}
