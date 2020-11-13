//
//  FirebaseAuthenticationService.swift
//  iBench
//
//  Created by Андрей Журавлев on 07.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

protocol FirebaseAuthenticationServiceable {
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> Void)
    func register(withEmail email: String?, password: String?, completion: @escaping (Result<User, Error>) -> ())
    func login(withEmail email: String?, password: String?, completion: @escaping (Result<User, Error>) -> ())
}

class FirebaseAuthenticationService {
    static let shared = FirebaseAuthenticationService()
    private init() {}
    
    private let auth = Auth.auth()
}

extension FirebaseAuthenticationService: FirebaseAuthenticationServiceable {
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
        }
        
        guard let auth = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func register(withEmail email: String?, password: String?, completion: @escaping (Result<User, Error>) -> ()) {
        guard Validators.isFilled(email: email, password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func login(withEmail email: String?, password: String?, completion: @escaping (Result<User, Error>) -> ()) {
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
