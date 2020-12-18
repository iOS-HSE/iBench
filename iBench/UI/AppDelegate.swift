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
        
        UserLocationService.shared.askUserPermissionForWhenInUseAuthorizationIfNeeded()
        _ = UserLocationService.shared.startUpdatingLocation()
        
        PersistantStoreService.shared.incrementLaunchesCount()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if PersistantStoreService.shared.isFirstLaunch {
            //onboarding preparations
            //return
        }
        
        let initialVC: UIViewController
        if CurrentUserManager.shared.isSignedIn {
            //route to mapVIewController
            let vc = MapViewController.initFromItsStoryboard()
            vc.viewModel = MapViewModel()
            let router = MapFlowRouter(initialVC: vc)
            vc.router = router
            initialVC = router.navigationController
        } else {
            let vc = RegisterViewController.initFromItsStoryboard()
            let router = AuthenticationFlowRouter(initialVC: vc)
            vc.router = router
            vc.viewModel = RegisterViewModel()
            initialVC = router.navigationController
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
    }

}

