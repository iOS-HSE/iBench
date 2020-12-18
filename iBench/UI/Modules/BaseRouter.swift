//
//  BaseRouter.swift
//  iBench
//
//  Created by Андрей Журавлев on 26.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

public protocol BaseRouting {
    var navigationController: UINavigationController { get }
}

public class BaseRouter {
    
    public let navigationController: UINavigationController
    
    init() {
        let nvc = UINavigationController()
        nvc.navigationBar.isHidden = true
        nvc.modalPresentationStyle = .fullScreen
        //disable pop swipe from left to right
        nvc.interactivePopGestureRecognizer?.isEnabled = false
        
        self.navigationController = nvc
    }
}

extension BaseRouter: BaseRouting {
    
}
