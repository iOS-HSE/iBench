//
//  FirestoreError.swift
//  iBench
//
//  Created by Андрей Журавлев on 26.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

enum FirestoreError: Error {
    case badData
    
    var localizedDescription: String {
        switch self {
            case .badData:
                return "Unable to decode document data"
        }
    }
}
