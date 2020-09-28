//
//  AppDelegate.swift
//  PiggyTestWeb
//
//  Created by Qing Li on 2020/9/25.
//  Copyright © 2020 Qing Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Without Scenedelegate and storyboard. Directly Use ViewController for initial View.
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow();
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible();
        
        return true
    }


}

