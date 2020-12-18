//
//  SettingsViewModel.swift
//  iBench
//
//  Created by user184905 on 12/15/20.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    var currentUser: CurrentUser? {
        didSet {
            didChange?()
        }
    }
    
    var name: String?
    var didChangeNameSuccessfully: (() -> Void)?
    
    private var currentUserListenerToken: SignalSubscriptionToken?
    
    let currentUserManager: CurrentUserManaging
    
    init(
        currentUserManager: CurrentUserManaging = CurrentUserManager.shared
    ) {
        self.currentUserManager = currentUserManager
        super.init()
        
        currentUserListenerToken = currentUserManager.currentUser.signal
            .addListener(skipCurrent: false, skipRepeats: true, listenerBlock: { [weak self] (currentUser) in
                self?.currentUser = currentUser
            })
    }
    
    deinit {
        currentUserManager.currentUser.signal.removeListener(currentUserListenerToken)
    }
    
}

extension SettingsViewModel: SettingsViewModeling {
    func changeName() {
        guard let name = name else {
            didGetError?("Проверьте введенное имя")
            return
        }
        currentUserManager.updateName(name: name) { (error) in
            if let error = error {
                self.didGetError?(error)
                return
            }
            self.didChangeNameSuccessfully?()
        }
    }
}
