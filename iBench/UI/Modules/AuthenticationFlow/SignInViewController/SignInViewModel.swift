//
//  SignInViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class SignInViewModel: BaseViewModel {
    
    var email: String?
    var password: String?
    
    let currentUserManager: CurrentUserManaging
    
    private var didAuthenticateSubscriptionToken: SignalSubscriptionToken?
    
    var didSignedInSuccessfully: (() -> Void)?
    
    init(
        currentUserManager: CurrentUserManaging = CurrentUserManager.shared
    ) {
        self.currentUserManager = currentUserManager
        super.init()
        didAuthenticateSubscriptionToken = currentUserManager.didAuthenticateSuccessfully.signal
            .addListener(skipCurrent: true, skipRepeats: false) { [weak self] (isSuccessfullAuthentication) in
                if isSuccessfullAuthentication {
                    self?.didSignedInSuccessfully?()
                }
            }
    }
    
    deinit {
        currentUserManager.didAuthenticateSuccessfully.signal.removeListener(didAuthenticateSubscriptionToken)
    }
}

extension SignInViewModel: SignInViewModeling {
    func signIn() {
        guard let email = email,
              let password = password else {
            didGetError?("Пожалуйста, проверьте правильность введенных данных")
            return
        }
        
        isLoading = true
        currentUserManager.login(email: email, password: password) { [weak self] (error) in
            guard let self = self else {
                return
            }
            self.isLoading = false
            if let error = error as NSError? {
                let message = self.currentUserManager.mapErrorMessage(for: error)
                self.didGetError?(message)
                return
            }
            self.didSignedInSuccessfully?()
        }
    }
}
