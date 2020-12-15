//
//  AddNewBenchViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import MapKit

protocol AddNewBenchRouting {
    func navigateBack(from: UIViewController, completion: (() -> Void)?)
}

protocol AddNewBenchViewModeling: BaseViewModeling {
    
}

class AddNewBenchViewController: BottomSheetViewController {
    
    var router: AddNewBenchRouting?
    var viewModel: AddNewBenchViewModeling? {
        didSet {
            viewModel?.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    print(self.debugDescription) // to silence warning
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewController(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
}

extension AddNewBenchViewController: BottomSheetBenchesDelegate {
    func didUpdateBenchLocation(_ bench: BenchObject) {
        
    }
    
    func didUpdateTapCoordinates(_ coordinates: CLLocationCoordinate2D) {
        
    }
    
    func didTapOutside() {
        
    }
    
}
