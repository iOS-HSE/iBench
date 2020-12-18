//
//  Validators.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class Validators {
    static func isFilled(email: String?, password: String?) -> Bool {
        guard let password = password,
              let email = email,
              !password.isEmpty, !email.isEmpty else {
            return false
        }
        return true
    }
    
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard let description = description,
              let sex = sex,
              let username = username,
              !description.isEmpty, !sex.isEmpty, !username.isEmpty else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
