//
//  HowToRouting.swift
//  iBench
//
//  Created by Андрей Журавлев on 18.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

class HowToRouter {
    
    weak var viewController: UIViewController?
    
    init(initialVC: UIViewController) {
        self.viewController = initialVC
    }
}

extension HowToRouter: HowToRouting {
    func presentRegisterViewController(_ completion: (() -> Void)?) {
        let vc = RegisterViewController.initFromItsStoryboard()
        vc.viewModel = RegisterViewModel()
        let router = AuthenticationFlowRouter(initialVC: vc)
        vc.router = router
        viewController?.view.window?.rootViewController = router.navigationController
    }
}
