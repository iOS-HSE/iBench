//
//  PersistantStoreService+User.swift
//  iBench
//
//  Created by Андрей Журавлев on 28.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

protocol PersistantStoreUserServiceable: class {
    var userObject: CurrentUser? { get set }
}

extension PersistantStoreService: PersistantStoreUserServiceable {
    var userObject: CurrentUser? {
        get {
            guard let data = keyValueStorage.object(forKey: Self.userObjectKey) as? Data else {
                return nil
            }
            guard let object = try? PropertyListDecoder().decode(CurrentUser.self, from: data) else {
                return nil
            }
            return object
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            keyValueStorage.set(key: Self.userObjectKey, value: data)
        }
    }
    
    private static let userObjectKey = "userObjectKey"
}
