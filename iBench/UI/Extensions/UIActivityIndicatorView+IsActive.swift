//
//  UIActivityIndicatorView+IsActive.swift
//  iBench
//
//  Created by Андрей Журавлев on 28.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    var isActive: Bool? {
        set {
            guard let newValue = newValue else {
                stopAnimating()
                return
            }
            
            if isAnimating != newValue {
                newValue ? startAnimating() : stopAnimating()
            }
        }
        get {
            isAnimating
        }
    }
    
}
