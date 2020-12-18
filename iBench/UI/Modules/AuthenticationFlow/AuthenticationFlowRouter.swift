//
//  AuthenticationFlowRouter.swift
//  iBench
//
//  Created by Андрей Журавлев on 26.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

final class AuthenticationFlowRouter {
    
    let navigationController: UINavigationController
    
    init(initialVC: UIViewController) {
        navigationController = UINavigationController(rootViewController: initialVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        //disable pop swipe from left to right
        navigationController.interactivePopGestureRecognizer?.isEnabled = false

    }
}

extension AuthenticationFlowRouter: RegisterRouting {
    func presentMapViewController(_ completion: (() -> Void)?) {
        let vc = MapViewController.initFromItsStoryboard()
        vc.viewModel = MapViewModel()
        let router = MapFlowRouter(initialVC: vc)
        vc.router = router
        navigationController.view.window?.rootViewController = router.navigationController
    }
    
    func presentSignInViewController(_ compleiton: (() -> Void)?) {
        if let presentedVC = navigationController.viewControllers.first(where: { $0 is SignInViewController }) {
            navigationController.popToViewController(presentedVC, animated: true, compleiton)
        } else {
            let vc = SignInViewController.initFromItsStoryboard()
            vc.viewModel = SignInViewModel()
            vc.router = self
            navigationController.pushViewController(vc, animated: true, compleiton)
        }
    }
    
    //move to extension signInViewControllerRouting protocol when it will be added
    func presentRegisterViewController(_ completion: (() -> Void)?) {
        if let registerVC = navigationController.viewControllers.first(where: { $0 is RegisterViewController }) {
            navigationController.popToViewController(registerVC, animated: true)
        } else {
            let vc = RegisterViewController.initFromItsStoryboard()
            vc.router = self
            vc.viewModel = RegisterViewModel()
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
}

extension AuthenticationFlowRouter: SignInRouting {
    
}
