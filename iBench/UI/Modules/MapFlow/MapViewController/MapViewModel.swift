//
//  MapViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

class MapViewModel: BaseViewModel {
    var benches: [BenchObject] = [] {
        didSet {
            didChange?()
        }
    }
    
    private let firestoreService: FirestoreBenchesServiceable
    
    private var benchesListener: ListenerRegistration?
    
    init(
        firestoreService: FirestoreBenchesServiceable = FirestoreService.shared
    ) {
        self.firestoreService = firestoreService
        super.init()
        
        benchesListener = firestoreService.getBenchesListener({ [weak self] (result) in
            self?.handleBenchesResult(result)
        })
    }
    
    deinit {
        benchesListener?.remove()
    }
    
    private func handleFirestoreError(error: Error) {
        self.didGetError?(error.localizedDescription) //TBD
    }
    
    private func handleBenchesResult(_ result: Result<[BenchObject], NSError>) {
        switch result {
            case .success(let benches):
                self.benches = benches
            case .failure(let error):
                self.handleFirestoreError(error: error)
        }
    }
}

extension MapViewModel: MapViewModeling {
}
