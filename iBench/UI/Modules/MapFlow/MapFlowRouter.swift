//
//  MapFlowRouter.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit
import CoreLocation

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
    func presentBenchInfoViewController(object: BenchObject, mapPreview: UIImage, _ completion: (() -> Void)?) {
        
    }
    
    func presentAddNewBenchViewController(coordinate: CLLocationCoordinate2D, _ completion: (() -> Void)?) {
        guard let mapVC = getTopViewController() as? MapViewController else {
            return
        }
        let childVC = AddNewBenchViewController.initFromItsStoryboard()
        mapVC.addChild(childVC)
        mapVC.view.addSubview(childVC.view)
        childVC.didMove(toParent: mapVC)
        
        let height = mapVC.view.frame.height
        let width  = mapVC.view.frame.width
        childVC.view.frame = CGRect(x: 0,
                                    y: mapVC.view.frame.maxY,
                                    width: width,
                                    height: height)
        completion?()
    }
}
