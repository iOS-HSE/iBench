//
//  CurrentUser.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser {
    let name: String
    let firebaseUid: String
    let email: String?
    
    init(firebaseUser: User) {
        self.name = firebaseUser.displayName ?? "Not given"
        self.firebaseUid = firebaseUser.uid
        self.email = firebaseUser.email
    }
}

extension CurrentUser: Equatable {
    
}
