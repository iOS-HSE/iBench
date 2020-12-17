//
//  Float+init.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

extension Float {
    init?(_ int: Int?) {
        guard let int = int else {
            return nil
        }
        self.init(int)
    }
}
