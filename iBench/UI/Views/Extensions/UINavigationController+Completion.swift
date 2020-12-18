//
//  UINavigationController+Completion.swift
//  iBench
//
//  Created by Андрей Журавлев on 07.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, _ completion: (()->Void)?) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let transitionCoordinator = transitionCoordinator else {
            DispatchQueue.main.async {
                completion?()
            }
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
    
    func popViewController(animated: Bool, _ completion: (()->Void)?) {
        popViewController(animated: animated)
        
        guard animated, let transitionCoordinator = transitionCoordinator else {
            DispatchQueue.main.async {
                completion?()
            }
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, _ completion: (()->Void)?) {
        popToViewController(viewController, animated: animated)
        
        guard animated, let transitionCoordinator = transitionCoordinator else {
            DispatchQueue.main.async {
                completion?()
            }
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
}
