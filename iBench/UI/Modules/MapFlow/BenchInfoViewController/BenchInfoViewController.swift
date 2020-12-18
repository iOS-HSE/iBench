//
//  BenchInfoViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import MapKit

protocol BenchInfoRouting {
    func presentAddNewBenchViewController(coordinate: LocationCoordinates, _ completion: (() -> Void)?)
    func presentAddNewBenchViewController(benchObject: BenchObject, _ completion: (() -> Void)?)
}

protocol BenchInfoViewModeling: BaseViewModeling {
    var benchObject: BenchObject { get set }
    var isCurrentUserBenchCreator: Bool { get }
    
    var userAddedName: String? { get }
}

class BenchInfoViewController: BottomSheetViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userAddedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIStackView!
    
    var router: BenchInfoRouting?
    var viewModel: BenchInfoViewModeling? {
        didSet {
            viewModel?.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
            viewModel?.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(title: "Ошибка", message: message, okHandler: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        setupGestures()
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewController(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateActivityIndicator()
        updateEditButton()
        updateRatingLabel()
        updateCommentLabel()
        updateUserAddedLabel()
    }
    
    private func updateActivityIndicator() {
        let isLoading = viewModel?.isLoading ?? false
        containerView.isHidden = isLoading
        activityIndicator.isActive = isLoading
    }
    
    private func updateEditButton() {
        let isCreator = viewModel?.isCurrentUserBenchCreator ?? true
        editButton.superview?.isHidden = !isCreator
    }
    
    private func updateRatingLabel() {
        guard let rating = viewModel?.benchObject.rating else {
            ratingLabel.text = "Нет рейтинга"
            return
        }
        ratingLabel.text = "Рейтинг \(String(format: "%d", rating))"
    }
    
    private func updateCommentLabel() {
        guard let comment = viewModel?.benchObject.comment else {
            commentLabel.text = "Нет комментария"
            return
        }
        commentLabel.text = comment
    }
    
    private func updateUserAddedLabel() {
        guard let userName = viewModel?.userAddedName else {
            userAddedLabel.text = "NA"
            return
        }
        userAddedLabel.text = "Добавил: \(userName)"
    }
    
    @IBAction func editButtonTapped() {
        collapseViewControllerWithoutPan {
            guard let object = self.viewModel?.benchObject else {
                return
            }
            self.router?.presentAddNewBenchViewController(benchObject: object, nil)
        }
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
        collapseViewControllerWithoutPan {
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
}

extension BenchInfoViewController: BottomSheetBenchesDelegate {
    
    func didUpdateBenchLocation(_ bench: BenchObject) {
        viewModel?.benchObject = bench
    }
    
    func didUpdateTapCoordinates(_ coordinates: LocationCoordinates) {
        collapseViewControllerWithoutPan {
            self.router?.presentAddNewBenchViewController(coordinate: coordinates, nil)
        }
    }
    
    func didTapOutside() {
        collapseViewControllerWithoutPan()
    }
    
}
