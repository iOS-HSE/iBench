//
//  FirestoreService+User.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

typealias UserResultResponse = (Result<CurrentUser?, Error>) -> Void

protocol FirestoreUserServiceable {
    func addUser(_ user: CurrentUser, completion: @escaping ((_ errorMessage: Error?) -> Void))
    func updateUsername(userId: String, _ userName: String, completion: @escaping UserResultResponse)
    func getUserFromDataBase(userId: String, completion: @escaping UserResultResponse)
}

extension FirestoreService: FirestoreUserServiceable {
    
    private var usersRef: CollectionReference {
        return firestore.collection(FirestorePathKeys.users)
    }
    
    func addUser(_ user: CurrentUser, completion: @escaping ((Error?) -> Void)) {
        let usersRef = self.usersRef
        usersRef.document(user.id).setData(user.dictionaryRepresentation) { (error) in
            completion(error)
        }
    }
    
    func updateUsername(userId: String, _ userName: String, completion: @escaping UserResultResponse) {
        let usersRef = self.usersRef
        let docRef = usersRef.document(userId)
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if snapshot == nil {
                completion(.success(nil))
            }
            guard let snapshot = snapshot,
                  var currentData = CurrentUser(document: snapshot) else {
                completion(.failure(FirestoreError.badData))
                return
            }
            currentData.name = userName
            docRef.setData(currentData.dictionaryRepresentation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(currentData))
            }
        }
    }
    
    func getUserFromDataBase(userId: String, completion: @escaping UserResultResponse) {
        let usersRef = self.usersRef
        usersRef.document(userId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if snapshot == nil {
                completion(.success(nil))
            }
            let currentData = CurrentUser(document: snapshot!)
            completion(.success(currentData))
        }
    }
}