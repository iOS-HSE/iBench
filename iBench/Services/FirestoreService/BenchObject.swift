//
//  BenchObject.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

struct BenchObject: Equatable {
    let id: String
    let lat: Double
    let lon: Double
    let rating: Float?
    var ratesCount: Int
    let comment: String?
    let userAddedId: String
    let addedAt: Int
    let photoUrl: String?
    
    var dictionaryRepresentation: [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "lat": lat,
            "lon": lon,
            "userAddedId": userAddedId,
            "addedAt": addedAt,
            "ratesCount": ratesCount,
        ]
        if let comment = comment {
            dict["comment"] = comment
        }
        if let photoUrl = photoUrl {
            dict["photoUrl"] = photoUrl
        }
        if let rating = rating {
            dict["rating"] = rating
        }
        return dict
    }
    
    init(id: String = UUID().uuidString,
         lat: Double,
         lon: Double,
         rating: Float? = nil,
         ratesCount: Int = 0,
         comment: String? = nil,
         userAddedId: String,
         addedAt: Int = Int(Date().timeIntervalSince1970),
         photoUrl: String? = nil) {
        self.id = id
        self.lat = lat
        self.lon = lon
        self.rating = rating
        self.comment = comment
        self.userAddedId = userAddedId
        self.addedAt = addedAt
        self.photoUrl = photoUrl
        self.ratesCount = ratesCount
    }
    
    init?(document: DocumentSnapshot) {
        let data = document.data()
        guard let id = data?["id"] as? String,
              let lat = data?["lat"] as? Double,
              let lon = data?["lon"] as? Double,
              let userAddedId = data?["userAddedId"] as? String,
              let addedAt = data?["addedAt"] as? Int else {
            return nil
        }
        let rating = data?["rating"] as? Float
        let comment = data?["comment"] as? String
        let photoUrl = data?["photoUrl"] as? String
        let ratesCount = data?["ratesCount"] as? Int ?? 0
        
        self.init(id: id,
                  lat: lat,
                  lon: lon,
                  rating: rating,
                  ratesCount: ratesCount,
                  comment: comment,
                  userAddedId: userAddedId,
                  addedAt: addedAt,
                  photoUrl: photoUrl)
    }
}
