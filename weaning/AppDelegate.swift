//
//  AppDelegate.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import UIKit
import AppTrackingTransparency
import FirebaseAnalytics
import FirebaseCore
import FirebaseAppCheck
import RevenueCat

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // To retrieve debug token for App Check on simulators
        // let providerFactory = AppCheckDebugProviderFactory()
        // AppCheck.setAppCheckProviderFactory(providerFactory)

        let providerFactory = AppCheckProviderService()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(false)
        #if RELEASE
            self.askForTrackingPermission()
        #endif

        // RevenueCatService.shared.configure()

        return true
    }

    func askForTrackingPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        Analytics.setAnalyticsCollectionEnabled(true)
                    default:
                        break
                    }
                }
            })
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
    }

}

extension AppDelegate {

    static var shared: AppDelegate {
        let delegate = UIApplication.shared.delegate

        guard let appDelegate = delegate as? AppDelegate else {
            fatalError("Cannot cast \(type(of: delegate)) to AppDelegate")
        }

        return appDelegate
    }

}
