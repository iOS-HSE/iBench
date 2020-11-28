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
    
    var isSignedIn: Bool { get }
    
    func createUser(name: String?, email: String?, password: String?, _ completion: @escaping (_ error: Error?) -> Void)
    func login(email: String?, password: String?, _ compleiton: @escaping (_ error: Error?) -> Void)
    func googleAuthenticate(googleUser: GIDGoogleUser!, error: Error!, completion: @escaping (_ error: Error?) -> Void)
    func updateName(name: String, _ completion: @escaping (_ errorMessage: String?) -> Void)
    
    func mapErrorMessage(for error: NSError) -> String
}

class CurrentUserManager: NSObject {
    
    private let authenticationService: FirebaseAuthenticationServiceable
    private let firestoreService: FirestoreServiceable
    private let userPersistantStoreService: PersistantStoreUserServiceable
    
    let currentUser = Emitter<CurrentUser?>(nil)
    let didAuthenticateSuccessfully = Emitter<Bool>(false)
    
    static let shared = CurrentUserManager()
    private init(
        authenticationService: FirebaseAuthenticationServiceable = FirebaseAuthenticationService.shared,
        firestoreService: FirestoreServiceable = FirestoreService.shared,
        persistantStoreService: PersistantStoreUserServiceable = PersistantStoreService.shared
    ) {
        self.authenticationService = authenticationService
        self.firestoreService = firestoreService
        self.userPersistantStoreService = persistantStoreService
    }
    
    private func setCurrentUser(_ user: CurrentUser?) {
        let oldValue = currentUser.value
        currentUser.value = user
        userPersistantStoreService.userObject = user
        if oldValue == nil, user != nil {
            didAuthenticateSuccessfully.value = true
        }
    }
}

extension CurrentUserManager: CurrentUserManaging {
    func createUser(name: String?, email: String?, password: String?, _ completion: @escaping (Error?) -> Void) {
        authenticationService.register(withEmail: email, password: password) { [weak self] (result) in
            switch result {
                case .success(let user):
                    var currentUser = CurrentUser(firebaseUser: user)
                    currentUser.name = name ?? "NA"
                    self?.firestoreService.addUser(currentUser) { (error) in
                        if let error = error {
                            completion(error)
                            return
                        }
                        self?.setCurrentUser(currentUser)
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func login(email: String?, password: String?, _ compleiton: @escaping (Error?) -> Void) {
        authenticationService.login(withEmail: email, password: password) { [weak self] (result) in
            switch result{
                case .success(let user):
                    let currentUser = CurrentUser(firebaseUser: user)
                    self?.setCurrentUser(currentUser)
                    compleiton(nil)
                case .failure(let error):
                    compleiton(error)
            }
        }
    }
    
    func googleAuthenticate(googleUser: GIDGoogleUser!, error: Error!, completion: @escaping (Error?) -> Void) {
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
                                            completion(error)
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
                                completion(error)
                        }
                    }
                case .failure(let error):
                    completion(error)
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
    
    var isSignedIn: Bool {
        authenticationService.currentUser != nil
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

extension CurrentUserManager {
    func mapErrorMessage(for error: NSError) -> String {
        switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue: return "Данный адрес почты уже используется"
            case AuthErrorCode.invalidEmail.rawValue:      return "Аккаунт не существует"
//            case AuthErrorCode.missingEmail.rawValue:      return "Please enter an email"
            case AuthErrorCode.wrongPassword.rawValue:     return "Неверный пароль"
            case AuthErrorCode.userNotFound.rawValue:      return "Пользователь не найден"
            case AuthErrorCode.weakPassword.rawValue:      return "Слишком слабый пароль. Пожалуйста, введите более сложный пароль"
                
            default:
                return error.localizedDescription
        }
    }
}
