//
//  AddNewBenchViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class AddNewBenchViewModel: BaseViewModel {
    
    var coordinates: LocationCoordinates
    var comment: String?
    var rating: Int?
    
    var didAddBenchSuccessfully: (() -> Void)?
    
    let firestoreService: FirestoreBenchesServiceable
    let currentUserManager: CurrentUserManaging
    
    init(coordinates: LocationCoordinates,
         firestoreService: FirestoreBenchesServiceable = FirestoreService.shared,
         currentUserManager: CurrentUserManaging = CurrentUserManager.shared) {
        self.coordinates = coordinates
        
        self.currentUserManager = currentUserManager
        self.firestoreService = firestoreService
    }
}

extension AddNewBenchViewModel: AddNewBenchViewModeling {
    func addBench() {
        guard let currentUserId = currentUserManager.currentUser.value?.id else {
            self.didGetError?("Нет текущего пользователя")
            return
        }
        let benchObject = BenchObject(lat: coordinates.lat,
                                      lon: coordinates.lon,
                                      rating: Float(rating),
                                      comment: comment,
                                      userAddedId: currentUserId)
        firestoreService.addBench(benchObject) { [weak self] (error) in
            if let error = error {
                self?.didGetError?(error.localizedDescription)
                return
            }
            self?.didAddBenchSuccessfully?()
        }
    }
}
