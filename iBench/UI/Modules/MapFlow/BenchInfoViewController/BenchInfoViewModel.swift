//
//  BenchInfoViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

class BenchInfoViewModel: BaseViewModel {
    var benchObject: BenchObject {
        didSet {
            didChange?()
        }
    }
    
    let firestoreUserService: FirestoreUserServiceable
    let firestoreBenchesService: FirestoreBenchesServiceable
    
    init(benchObject: BenchObject,
         firestoreUserService: FirestoreUserServiceable = FirestoreService.shared,
         firestoreBenchesService: FirestoreBenchesServiceable = FirestoreService.shared) {
        self.benchObject = benchObject
        
        self.firestoreUserService = firestoreUserService
        self.firestoreBenchesService = firestoreBenchesService
    }
}

extension BenchInfoViewModel: BenchInfoViewModeling {
    
}
