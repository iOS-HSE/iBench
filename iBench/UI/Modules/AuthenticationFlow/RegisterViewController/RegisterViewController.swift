//
//  RegisterViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol RegisterViewControllerRouting {
    func presentMapViewController(_ completion: (() -> Void)?)
    func presentSignInViewController(_ compleiton: (() -> Void)?)
}

protocol RegisterViewModeling: BaseViewModeling {
    var name: String? { get set }
    var email: String? { get set }
    var password: String? { get set }
    
    var didRegisterSuccessfully: (() -> Void)? { get set }
    
    func register()
    
}

final class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var containerViewYPositionAnchor: NSLayoutConstraint!
    
    let containerViewYPositionOffsetDefaultValue: CGFloat = 30
    
    var router: RegisterViewControllerRouting?
    var viewModel: RegisterViewModeling! {
        didSet {
            /// `weak self` для того, чтобы не происходило цикла ссылок и утечек памяти. Стоит писать всегда для
            /// вещей, которые  происходят в отдельном потоке
            viewModel.didChange = { [weak self] in
                /// `DispatchQueue.main` поток для изменения UI. Изменения UI не в `main` потоке вызовет краш.
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
            viewModel.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(title: "Ошибка", message: message, okHandler: nil)
                }
            }
            viewModel.didRegisterSuccessfully = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.showMessageAlert(message: "Successful registration")
//                    self?.router?.presentMapViewController(nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    //MARK: Setup
    
    private func setup() {
        
    }
    
    //MARK: Update
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateRegisterButton()
    }
    
    private func updateRegisterButton() {
        let isAllowedToTap = viewModel.name != nil &&
            viewModel.email != nil &&
            viewModel.password != nil &&
            !viewModel.name!.isEmpty &&
            !viewModel.email!.isEmpty &&
            !viewModel.password!.isEmpty
        registerButton.isUserInteractionEnabled = isAllowedToTap
        registerButton.backgroundColor = isAllowedToTap ? .iBenchMarine : .lightGray
    }
    
}

//MARK: Actions

extension RegisterViewController {
    @IBAction func nameEditingChanged() {
        viewModel.name = nameTextField.text
        update()
    }
    
    @IBAction func emailEditingChanged() {
        viewModel.email = emailTextField.text
        update()
    }
    
    @IBAction func passwordEditingChanged() {
        viewModel.password = passwordTextField.text
        update()
    }
    
    @IBAction func registerButtonTapped() {
        viewModel.register()
    }
}

extension RegisterViewController {
    
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
