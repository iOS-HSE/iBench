//
//  UIStoryboard+UIViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 07.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardLoadable {
    
}

public protocol StoryboardLoadable {
    static func initFromItsStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    
    public static func initFromItsStoryboard() -> Self {
        let storyboardName = self.typeName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiate(self)
        return viewController
    }
}

extension UIStoryboard {
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = self.instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(VC.self.typeName)")
        }
        
        return vc
    }
}
