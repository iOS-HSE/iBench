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
    var didAuthenticateSuccessfully: Emitter<Bool> { get }
    
    func createUser(name: String?, email: String?, password: String?, _ completion: @escaping (_ errorMessage: String?) -> Void)
    func login(email: String?, password: String?, _ compleiton: @escaping (_ errorMessage: String?) -> Void)
    func googleAuthenticate(googleUser: GIDGoogleUser!, error: Error!, completion: @escaping (_ errorMessage: String?) -> Void)
    func updateName(name: String, _ completion: @escaping (_ errorMessage: String?) -> Void)
}

class CurrentUserManager: NSObject {
    
    private let authenticationService: FirebaseAuthenticationServiceable
    private let firestoreService: FirestoreServiceable
    
    let currentUser = Emitter<CurrentUser?>(nil)
    let didAuthenticateSuccessfully = Emitter<Bool>(false)
    
    static let shared = CurrentUserManager()
    private init(
        authenticationService: FirebaseAuthenticationServiceable = FirebaseAuthenticationService.shared,
        firestoreService: FirestoreServiceable = FirestoreService.shared
    ) {
        self.authenticationService = authenticationService
        self.firestoreService = firestoreService
    }
    
    private func setCurrentUser(_ user: CurrentUser?) {
        let oldValue = currentUser.value
        currentUser.value = user
        if oldValue == nil, user != nil {
            didAuthenticateSuccessfully.value = true
        }
    }
}

extension CurrentUserManager: CurrentUserManaging {
    func createUser(name: String?, email: String?, password: String?, _ completion: @escaping (String?) -> Void) {
        authenticationService.register(withEmail: email, password: password) { [weak self] (result) in
            switch result {
                case .success(let user):
                    var currentUser = CurrentUser(firebaseUser: user)
                    currentUser.name = name ?? "NA"
                    self?.firestoreService.addUser(currentUser) { (error) in
                        if let error = error {
                            completion(error.localizedDescription)
                            return
                        }
                        self?.setCurrentUser(currentUser)
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error.localizedDescription)
            }
        }
    }
    
    func login(email: String?, password: String?, _ compleiton: @escaping (String?) -> Void) {
        authenticationService.login(withEmail: email, password: password) { [weak self] (result) in
            switch result{
                case .success(let user):
                    let currentUser = CurrentUser(firebaseUser: user)
                    self?.setCurrentUser(currentUser)
                    compleiton(nil)
                case .failure(let error):
                    compleiton(error.localizedDescription)
            }
        }
    }
    
    func googleAuthenticate(googleUser: GIDGoogleUser!, error: Error!, completion: @escaping (String?) -> Void) {
        authenticationService.googleLogin(user: googleUser, error: error) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
                case .success(let user):
                    self.firestoreService.getUserFromDataBase(userId: user.uid) { (result) in
                        switch result {
                            case .success(let currentUser):
                                if currentUser == nil {
                                    let currentId = self.authenticationService.currentUser?.uid
                                    let currentGoogleUser = CurrentUser(googleUser: googleUser, id: currentId)
                                    self.firestoreService.addUser(currentGoogleUser) { (error) in
                                        if let error = error {
                                            completion(error.localizedDescription)
                                            return
                                        }
                                        self.setCurrentUser(currentGoogleUser)
                                        completion(nil)
                                    }
                                } else {
                                    self.setCurrentUser(currentUser)
                                    completion(nil)
                                }
                            case .failure(let error):
                                completion(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    completion(error.localizedDescription)
            }
        }
    }
    
    func updateName(name: String, _ completion: @escaping (String?) -> Void) {
        guard let currentUserId = currentUser.value?.id else {
            completion("No current user")
            return
        }
        firestoreService.updateUsername(userId: currentUserId, name) { [weak self] (result) in
            switch result {
                case .success(let user):
                    self?.setCurrentUser(user)
                    completion(nil)
                case .failure(let error):
                    completion(error.localizedDescription)
            }
        }
    }
}

extension CurrentUserManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.googleAuthenticate(googleUser: user, error: error) { (_) in
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
