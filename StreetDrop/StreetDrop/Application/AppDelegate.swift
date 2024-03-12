//
//  AppDelegate.swift
//  StreetDrop
//
//  Created by Joseph Cha on 2023/05/02.
//

import UIKit
import UserNotifications
import AppTrackingTransparency

import Firebase
import FirebaseMessaging
import GoogleMobileAds
import NMapsMap
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let fcmRepository: FCMRepository = DefaultFCMRepository()
    private let disposedBag: DisposeBag = .init()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.setupAppDependencies()
        self.requestNotificationAuthorization()
        
        application.registerForRemoteNotifications()

        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        return [[.banner, .list, .sound] ]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
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

// MARK: - Private Methods

private extension AppDelegate {
    func setupAppDependencies() {
        FirebaseApp.configure()
        NMFAuthManager.shared().clientId = Bundle.main.naverMapsClientID
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { [weak self] granted, _ in
            granted ? print("알림 등록이 완료되었습니다.") : Void()
            self?.requestIDFAAuthorization()
        }
    }
    
    func requestIDFAAuthorization() {
        // 개인 맞춤형 광고를 제공하고 있지 않음. (Admob 추가용)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
            }
        }
    }
}
