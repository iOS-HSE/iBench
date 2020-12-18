//
//  MapFlowRouter.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

class MapFlowRouter {
    
    let navigationController: UINavigationController
    
    init(initialVC: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: initialVC)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        //disable pop swipe from left to right
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension MapFlowRouter: MapRouting {
    private func add(bottomSheetVC: BottomSheetViewController, to parentVC: UIViewController) {
        parentVC.addChild(bottomSheetVC)
        parentVC.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: parentVC)
        
        let height = parentVC.view.frame.height
        let width  = parentVC.view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0,
                                    y: parentVC.view.frame.maxY,
                                    width: width,
                                    height: height)
    }
    
    func presentBenchInfoViewController(object: BenchObject, _ completion: (() -> Void)?) {
        guard let mapVC = navigationController.topViewController as? MapViewController else {
            return
        }
        let childVC = BenchInfoViewController.initFromItsStoryboard()
        childVC.viewModel = BenchInfoViewModel(benchObject: object)
        childVC.router = self
        mapVC.bottomSheetDelegate = childVC
        add(bottomSheetVC: childVC, to: mapVC)
        completion?()
    }
    
    func presentAddNewBenchViewController(coordinate: LocationCoordinates, _ completion: (() -> Void)?) {
        guard let mapVC = navigationController.topViewController as? MapViewController else {
            return
        }
        let childVC = AddNewBenchViewController.initFromItsStoryboard()
        childVC.viewModel = AddNewBenchViewModel(coordinates: coordinate)
        childVC.router = self
        mapVC.bottomSheetDelegate = childVC
        add(bottomSheetVC: childVC, to: mapVC)
        completion?()
    }
    
    func presentSearchViewController(_ completion: (() -> Void)?) {
        
        let searchVC = SearchViewController.initFromItsStoryboard()
        searchVC.viewModel = SearchViewModel()
        searchVC.router = self
        if let mapVC = navigationController.topViewController as? MapViewController {
            searchVC.delegate = mapVC
        }
        
//        searchVC.modalPresentationStyle = .over
        navigationController.pushViewController(searchVC, animated: true, completion)
    }
}

extension MapFlowRouter: BenchInfoRouting, AddNewBenchRouting {
    func presentAddNewBenchViewController(benchObject: BenchObject, _ completion: (() -> Void)?) {
        guard let mapVC = getTopViewController() as? MapViewController else {
            return
        }
        let childVC = AddNewBenchViewController.initFromItsStoryboard()
        childVC.viewModel = AddNewBenchViewModel(benchObject: benchObject)
        childVC.router = self
        mapVC.bottomSheetDelegate = childVC
        add(bottomSheetVC: childVC, to: mapVC)
        completion?()
    }
}

extension MapFlowRouter: SearchRouting {
    func navigateBack(from vc: UIViewController, _ completion: (() -> Void)?) {
        if let navigationTopVC = navigationController.topViewController,
           vc == navigationTopVC {
            navigationController.popViewController(animated: true, completion)
        }
    }
}
