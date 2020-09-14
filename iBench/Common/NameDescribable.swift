//
//  NameDescribable.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }
    
    static var typeName: String {
        return String(describing: self)
    }
    
}
