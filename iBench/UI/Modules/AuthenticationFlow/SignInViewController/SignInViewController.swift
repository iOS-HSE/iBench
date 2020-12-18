//
//  SignInViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol SignInRouting: AuthenticationRouting {
    func presentRegisterViewController(_ completion: (() -> Void)?)
}

protocol SignInViewModeling: BaseViewModeling {
    var email: String? { get set }
    var password: String? { get set }
    
    var didSignedInSuccessfully: (() -> Void)? { get set }
    
    func signIn()
}

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerViewYPositionAnchor: NSLayoutConstraint!
    
    let containerViewYPositionOffsetDefaultValue: CGFloat = 0
    
    var router: SignInRouting?
    var viewModel: SignInViewModeling! {
        didSet {
            viewModel.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
            viewModel.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(title: "Ошибка", message: message, okHandler: nil)
                }
            }
            viewModel.didSignedInSuccessfully = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard self?.isViewLoaded ?? false, self?.view.window != nil else {
                        return
                    }
//                    self?.showMessageAlert(message: "Successful")
                    self?.router?.presentMapViewController(nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        GIDSignIn.sharedInstance()?.presentingViewController = nil
    }
    
    private func setup() {
        
    }
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateActivityIndicator()
        updateSignInButton()
    }
    
    private func updateSignInButton() {
        let isAllowedToTap = viewModel.email != nil &&
            viewModel.password != nil &&
            !viewModel.email!.isEmpty &&
            !viewModel.password!.isEmpty
        signInButton.isUserInteractionEnabled = isAllowedToTap
        signInButton.backgroundColor = isAllowedToTap ? .iBenchMarine : .lightGray
    }
    
    private func updateActivityIndicator() {
        activityIndicator.isActive = viewModel.isLoading
        buttonsStackView.isHidden = viewModel.isLoading
    }
}

//MARK: Actions

extension SignInViewController {
    @IBAction func emailEditingChanged() {
        viewModel.email = emailTextField.text
        update()
    }
    
    @IBAction func passwordEditingChanged() {
        viewModel.password = passwordTextField.text
        update()
    }
    
    @IBAction func signInButtonTapped() {
        viewModel.signIn()
    }
    
    @IBAction func registerButtonTapped() {
        router?.presentRegisterViewController(nil)
    }
}

//MARK: Keyboard

extension SignInViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let conatinerViewBottomYCoord = containerView.frame.maxY
        let keyboardUpperYCoord = view.frame.height - keyboardFrame.height
        if keyboardUpperYCoord < conatinerViewBottomYCoord {
            containerViewYPositionAnchor.constant = keyboardUpperYCoord - conatinerViewBottomYCoord
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseOut) {
                self.containerView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerViewYPositionAnchor.constant = containerViewYPositionOffsetDefaultValue
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut) {
            self.containerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
}
