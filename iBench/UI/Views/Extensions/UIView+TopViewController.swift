//
//  UIView+TopViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//  https://stackoverflow.com/questions/6131205/how-to-find-topmost-view-controller-on-ios/11793471

import UIKit

public extension UIWindow {
    
    var visibleViewController: UIViewController? {
        UIWindow.getVisibleViewControllerFrom(rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

func getTopViewController() -> UIViewController? {
    
    let appDelegate = UIApplication.shared.delegate
    if let window = appDelegate!.window {
        return window?.visibleViewController
    }
    return nil
}
