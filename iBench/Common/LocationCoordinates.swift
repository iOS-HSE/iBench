//
//  LocationCoordinates.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationCoordinates {
    let lat: Double
    let lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    init(coordinates: CLLocationCoordinate2D) {
        self.lat = coordinates.latitude
        self.lon = coordinates.longitude
    }
}
