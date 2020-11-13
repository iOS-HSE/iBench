//
//  CurrentUserManager.swift
//  iBench
//
//  Created by Андрей Журавлев on 07.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

protocol CurrentUserManaging {
    var currentUser: Emitter<CurrentUser?> { get }
    
    func createUser(email: String?, password: String?, _ completion: @escaping (_ errorMessage: String?) -> Void)
    func login(email: String?, password: String?, _ compleiton: @escaping (_ errorMessage: String?) -> Void)
    func googleAuthenticate(user: GIDGoogleUser!, error: Error!, completion: @escaping (_ errorMessage: String?) -> Void)
}

class CurrentUserManager {
    
    private let authenticationService: FirebaseAuthenticationServiceable
    
    let currentUser = Emitter<CurrentUser?>(nil)
    
    static let shared = CurrentUserManager()
    private init(
        authenticationService: FirebaseAuthenticationServiceable = FirebaseAuthenticationService.shared
    ) {
        self.authenticationService = authenticationService
    }
    
}

extension CurrentUserManager: CurrentUserManaging {
    func createUser(email: String?, password: String?, _ completion: @escaping (String?) -> Void) {
        authenticationService.register(withEmail: email, password: password) { (result) in
            switch result {
                case .success(let user):
                    self.currentUser.value = CurrentUser(firebaseUser: user)
                    completion(nil)
                case .failure(let error):
                    completion(error.localizedDescription)
            }
        }
    }
    
    func login(email: String?, password: String?, _ compleiton: @escaping (String?) -> Void) {
        authenticationService.login(withEmail: email, password: password) { (result) in
            switch result{
                case .success(let user):
                    self.currentUser.value = CurrentUser(firebaseUser: user)
                    compleiton(nil)
                case .failure(let error):
                    compleiton(error.localizedDescription)
            }
        }
    }
    
    func googleAuthenticate(user: GIDGoogleUser!, error: Error!, completion: @escaping (String?) -> Void) {
        authenticationService.googleLogin(user: user, error: error) { (result) in
            
        }
    }
}
