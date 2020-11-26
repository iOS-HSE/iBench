//
//  RegisterViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

final class RegisterViewModel: BaseViewModel {
    
    var email: String?
    var name: String?
    var password: String?
    
    let currentUserManager: CurrentUserManaging
    
    private var didAuthenticateSubscriptionToken: SignalSubscriptionToken?
    
    var didRegisterSuccessfully: (() -> Void)?
    
    init(
        currentUserManager: CurrentUserManaging = CurrentUserManager.shared
    ) {
        self.currentUserManager = currentUserManager
        super.init()
        didAuthenticateSubscriptionToken = currentUserManager.didAuthenticateSuccessfully.signal.addListener(skipCurrent: true, skipRepeats: false) { [weak self] (isSuccessfullAuthentication) in
            if isSuccessfullAuthentication {
                self?.didRegisterSuccessfully?()
            }
        }
    }
    
    deinit {
        currentUserManager.didAuthenticateSuccessfully.signal.removeListener(didAuthenticateSubscriptionToken)
    }
    
}

extension RegisterViewModel: RegisterViewModeling {
    func register() {
        guard let email = email,
              let name = name,
              let password = password else {
            didGetError?("Пожалуйста, проверьте правильность введенных данных")
            return
        }
        currentUserManager.createUser(name: name, email: email, password: password) { [weak self] (error) in
            if let error = error {
                self?.didGetError?(error)
                return
            }
        }
    }
}
