//
//  BenchInfoViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import MapKit

protocol BenchInfoViewModeling: BaseViewModeling {
    var benchObject: BenchObject { get set }
}

class BenchInfoViewController: BottomSheetViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userAddedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var viewModel: BenchInfoViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupGestures()
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewController(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @IBAction func editButtonTapped() {
        
    }
    
    @IBAction func routeToBenchButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }
        let latitude = viewModel.benchObject.lat
        let longitude = viewModel.benchObject.lon
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Лавка"
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

extension BenchInfoViewController: BottomSheetBenchesDelegate {
    
    func didUpdateBenchLocation(_ bench: BenchObject) {
        viewModel?.benchObject = bench
    }
    
    func didUpdateTapCoordinates(_ coordinates: LocationCoordinates) {
        //do nothing
    }
    
    func didTapOutside() {
        
    }
    
}
