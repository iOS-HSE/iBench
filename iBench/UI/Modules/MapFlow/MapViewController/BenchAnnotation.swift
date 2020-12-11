//
//  BenchAnnotation.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import MapKit

class BenchAnnotation: NSObject {
    
    let benchObject: BenchObject
    
    init(benchObject: BenchObject) {
        self.benchObject = benchObject
    }
}

extension BenchAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: benchObject.lat, longitude: benchObject.lon)
    }
    
    
}

