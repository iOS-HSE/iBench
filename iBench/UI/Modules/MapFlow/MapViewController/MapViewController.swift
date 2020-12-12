//
//  MapViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import MapKit

protocol MapRouting {
    
}

protocol MapViewModeling: BaseViewModeling {
    var benches: [BenchObject] { get }
    
}

class MapViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var router: MapRouting?
    var viewModel: MapViewModeling! {
        didSet {
            viewModel.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func update() {
        updateMapView()
    }
    
    private func updateMapView() {
        //not effective but bruh
        mapView.removeAnnotations(mapView.annotations)
        let benchAnnotations = viewModel.benches.map(BenchAnnotation.init)
        mapView.addAnnotations(benchAnnotations)
    }
    
    @IBAction func settingsTapped() {
        
    }
    
    @IBAction func searchTapped() {
        
    }
    
    @IBAction func homeButtonTapped() {
        
    }
    
    @IBAction func addNewBenchTapped() {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
