//
//  UILabel+Rotation.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

@IBDesignable
class RotatableLabel: UILabel {
    
    @IBInspectable
    var rotation: CGFloat = 0 {
        didSet {
            rotateLabel(degrees: rotation)
            layoutIfNeeded()
        }
    }
    
    func rotateLabel(degrees: CGFloat)  {
        let radiansPerDegree = CGFloat(CGFloat(Double.pi) / CGFloat(180.0))
        let radians = radiansPerDegree * degrees
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}
