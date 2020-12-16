//
//  AddNewBenchViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class AddNewBenchViewModel: BaseViewModel {
    
    var coordinates: LocationCoordinates?
    var benchObject: BenchObject?
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
    
    init(benchObject: BenchObject,
         firestoreService: FirestoreBenchesServiceable = FirestoreService.shared,
         currentUserManager: CurrentUserManaging = CurrentUserManager.shared) {
        self.benchObject = benchObject
        
        self.firestoreService = firestoreService
        self.currentUserManager = currentUserManager
    }
}

extension AddNewBenchViewModel: AddNewBenchViewModeling {
    func addBench() {
        guard let currentUserId = currentUserManager.currentUser.value?.id else {
            self.didGetError?("Нет текущего пользователя")
            return
        }
        guard let coordinates = coordinates else {
            return
        }
        let benchObject = BenchObject(lat: coordinates.lat,
                                      lon: coordinates.lon,
                                      rating: Float(rating),
                                      comment: comment,
                                      userAddedId: currentUserId)
        isLoading = true
        firestoreService.addBench(benchObject) { [weak self] (error) in
            self?.isLoading = false
            if let error = error {
                self?.didGetError?(error.localizedDescription)
                return
            }
            self?.didAddBenchSuccessfully?()
        }
    }
    
    func saveBenchChanges() {
        guard let oldBench = benchObject else {
            return
        }
        let newBench = BenchObject(id: oldBench.id,
                                   lat: oldBench.lat,
                                   lon: oldBench.lon,
                                   rating: Float(rating),
                                   ratesCount: oldBench.ratesCount,
                                   comment: comment,
                                   userAddedId: oldBench.userAddedId)
        
        isLoading = true
        firestoreService.updateBench(newBench) { [weak self] (error) in
            self?.isLoading = false
            if let error = error {
                self?.didGetError?(error.localizedDescription)
                return
            }
            self?.didAddBenchSuccessfully?()
        }
    }
    
    /// If `true` then vm is in `edit bench info` mode. Otherwise in `add new bench mode`
    var isEditingMode: Bool {
        benchObject != nil
    }
}
