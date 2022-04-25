//
//  AppDelegate.swift
//  Plaid
//
//  Created by Alena Nesterkina on 21.04.22.
//

import UIKit
import LinkKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let viewModel = ViewModel(manager: PlaidAPIManager(), data: LinkModel())
        let controller = ViewController()
        controller.viewModel = viewModel
        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else {
            return false
        }

        guard let linkOAuthHandler = window?.rootViewController as? LinkOAuthHandling,
              let handler = linkOAuthHandler.linkHandler
        else {
            return false
        }

        handler.continue(from: webpageURL)
        return true
    }
}

