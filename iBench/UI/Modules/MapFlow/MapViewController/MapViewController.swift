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
    func presentBenchInfoViewController(object: BenchObject,_ completion: (() -> Void)?)
    func presentAddNewBenchViewController(coordinate: LocationCoordinates, _ completion: (() -> Void)?)
}

protocol BottomSheetBenchesDelegate: class {
    func didUpdateBenchLocation(_ bench: BenchObject)
    func didUpdateTapCoordinates(_ coordinates: LocationCoordinates)
    func didTapOutside()
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
            viewModel.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(title: "Ошибка", message: message, okHandler: nil)
                }
            }
        }
    }
    weak var bottomSheetDelegate: BottomSheetBenchesDelegate?
    
    var selectedPin: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        centerOnUserLocation()
    }
    
    private func setup() {
        setupMapView()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.userTrackingMode = .follow
    }
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateMapView()
    }
    
    private func updateMapView() {
        //not effective but whatever
        mapView.removeAnnotations(mapView.annotations)
        let benchAnnotations = viewModel.benches.map(BenchAnnotation.init)
        mapView.addAnnotations(benchAnnotations)
    }
    
    private func centerOnUserLocation() {
        let userLoc = mapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: userLoc, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func settingsTapped() {
        
    }
    
    @IBAction func searchTapped() {
        
    }
    
    @IBAction func homeButtonTapped() {
        
    }
    
    @IBAction func userLocationTapped() {
        centerOnUserLocation()
    }
    
    @IBAction func mapLongTapped(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else {
            return
        }
        mapView.deselectAnnotation(nil, animated: true)
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        let coord = LocationCoordinates(coordinates: newCoordinates)
        if let selected = selectedPin {
            mapView.removeAnnotation(selected)
            selectedPin = annotation
            mapView.addAnnotation(annotation)
        }
        if let delegate = bottomSheetDelegate {
            delegate.didUpdateTapCoordinates(coord)
            if selectedPin == nil {
                selectedPin = annotation
                mapView.addAnnotation(annotation)
            }
            return
        }
        selectedPin = annotation
        mapView.addAnnotation(annotation)
        router?.presentAddNewBenchViewController(coordinate: coord, nil)
    }
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        mapView.deselectAnnotation(nil, animated: true)
        bottomSheetDelegate?.didTapOutside()
        if let selected = selectedPin {
            mapView.removeAnnotation(selected)
            return
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let benchAnnotation = view.annotation as? BenchAnnotation else {
            return
        }        
        
        self.router?.presentBenchInfoViewController(object: benchAnnotation.benchObject, nil)
        
    }
    
}
