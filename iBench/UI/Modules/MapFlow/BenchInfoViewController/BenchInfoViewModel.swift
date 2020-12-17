//
//  BenchInfoViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class BenchInfoViewModel: BaseViewModel {
    var benchObject: BenchObject {
        didSet {
            didChange?()
        }
    }
    
    var userAddedName: String?
    var isCurrentUserBenchCreator: Bool {
        guard let userId = currentUserManager.currentUser.value?.id else {
            return false
        }
        return benchObject.userAddedId == userId
    }
    
    let firestoreUserService: FirestoreUserServiceable
    let firestoreBenchesService: FirestoreBenchesServiceable
    let currentUserManager: CurrentUserManaging
    
    init(benchObject: BenchObject,
         firestoreUserService: FirestoreUserServiceable = FirestoreService.shared,
         firestoreBenchesService: FirestoreBenchesServiceable = FirestoreService.shared,
         currentUserManager: CurrentUserManaging = CurrentUserManager.shared) {
        self.benchObject = benchObject
        
        self.firestoreUserService = firestoreUserService
        self.firestoreBenchesService = firestoreBenchesService
        self.currentUserManager = currentUserManager
        
        super.init()
        
        getUserAddedName()
    }
    
    private func getUserAddedName() {
        if isCurrentUserBenchCreator {
            self.userAddedName = "Вы"
            return
        }
        isLoading = true
        firestoreUserService.getUserFromDataBase(userId: benchObject.userAddedId) { [weak self] (result) in
            self?.isLoading = false
            switch result {
                case .success(let userObject):
                    self?.userAddedName = userObject?.name
                    self?.didChange?()
                case .failure(let error):
                    self?.didGetError?(error.localizedDescription)
            }
        }
    }
}

extension BenchInfoViewModel: BenchInfoViewModeling {
    
    
}
