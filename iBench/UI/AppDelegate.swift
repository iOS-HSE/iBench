//
//  AppDelegate.swift
//  iBench
//
//  Created by Андрей Журавлев on 10.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = CurrentUserManager.shared
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialVC = RegisterViewController.initFromItsStoryboard()
        let router = AuthenticationFlowRouter(initialVC: initialVC)
        initialVC.viewModel = RegisterViewModel()
        initialVC.router = router
        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
    }

}

