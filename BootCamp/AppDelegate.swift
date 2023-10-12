//
//  AppDelegate.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

