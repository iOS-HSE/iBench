//
//  SearchViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 17.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

class SearchViewModel: BaseViewModel {
    
    var benches: [BenchObject] = [] {
        didSet {
            didChange?()
        }
    }
    
    var filteredBenches: [BenchObject] = []
    
    var distance: Double = 100 {
        didSet {
            applyFilter()
        }
    }
    
    let firestoreUserService: FirestoreUserServiceable
    let firestoreBenchesService: FirestoreBenchesServiceable
    let locationService: UserLocationServiceable
    
    var benchesListener: ListenerRegistration?
    
    init(
        firestoreUserService: FirestoreUserServiceable = FirestoreService.shared,
        firestoreBenchesService: FirestoreBenchesServiceable = FirestoreService.shared,
        locationService: UserLocationServiceable = UserLocationService.shared
    ) {
        self.firestoreUserService = firestoreUserService
        self.firestoreBenchesService = firestoreBenchesService
        self.locationService = locationService
        super.init()
        
        benchesListener = firestoreBenchesService.getBenchesListener { [weak self] (result) in
            switch result {
                case .success(let benches):
                    self?.benches = benches
                case .failure(_):
                    //TBD
                    break
            }
        }
    }
    
    deinit {
        benchesListener?.remove()
    }
    
    private func applyFilter() {
        filteredBenches = benches.filter {
            self.getDistanceTo(bench: $0) ?? Double.greatestFiniteMagnitude < self.distance
        }
        didChange?()
    }
    
}

extension SearchViewModel: SearchViewModeling {
    var numberOfRows: Int {
        filteredBenches.count
    }
    
    var isPreciseLocationAvailable: Bool {
        locationService.isFullAccuracyLocationEnabled
    }
    
    func getBench(at indexPath: IndexPath) -> BenchObject? {
        guard filteredBenches.indices ~= indexPath.row else {
            return nil
        }
        return filteredBenches[indexPath.row]
    }
    
    func getDistanceTo(bench: BenchObject) -> Double? {
        let coord = LocationCoordinates(lat: bench.lat, lon: bench.lon)
        return locationService.getDistanceFromUserLocation(to: coord)
    }
    
    
}
