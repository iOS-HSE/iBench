//
//  AppDelegate.swift
//  iBench
//
//  Created by Андрей Журавлев on 10.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialVC = ViewController.initFromItsStoryboard()
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

