//
//  UserProfileViewModel.swift
//  iBench
//
//  Created by Hacker Man on 17.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class UserProfileViewModel: BaseViewModel {
    
    var commentsLeftCount: Int = 0
    var addedBenchesCount: Int = 0
    
    let currentUserManager: CurrentUserManaging
    let firestoreService: FirestoreBenchesServiceable
    
    var currentUserListenerToken: SignalSubscriptionToken?
    
    init(
        currentUserManager: CurrentUserManaging = CurrentUserManager.shared,
        firestoreService: FirestoreBenchesServiceable = FirestoreService.shared
    ) {
        self.currentUserManager = currentUserManager
        self.firestoreService = firestoreService
        super.init()
        
        currentUserListenerToken = currentUserManager.currentUser.signal
            .addListener(skipCurrent: false, skipRepeats: true, listenerBlock: { (_) in
                self.didChange?()
            })
        
    }
    
    deinit {
        currentUserManager.currentUser.signal.removeListener(currentUserListenerToken)
    }
}

extension UserProfileViewModel: UserProfileViewModeling {
    var userName: String {
        currentUserManager.currentUser.value?.name ?? "NA"
    }
    
    func logout(_ completion: ((String?) -> Void)?) {
        currentUserManager.logOut { (error) in
            if let error = error {
                completion?(error.localizedDescription)
                return
            }
            completion?(nil)
        }
    }
}
