//
//  NibLoadable.swift
//  iBench
//
//  Created by Андрей Журавлев on 07.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol NibLoadable: class, NameDescribable {
    static var defaultNib: UINib { get }
}

extension NibLoadable {
    
    static var defaultNib: UINib {
        UINib(nibName: self.typeName, bundle: Bundle(for: self))
    }
}
