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

class AddNewBenchViewController: BaseViewController {
    
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
    
    var defaultSheetYCoordinate: CGFloat {
        UIScreen.main.bounds.height * 0.6 // 40% of screen will be taken by this sheet
    }
    var maximumSheetYCoordinate: CGFloat {
        UIScreen.main.bounds.height * 0.1 // 90% of screen will be taken by this sheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height * 0.7
            self?.view.frame = CGRect(x: 0,
                                      y: yComponent,
                                      width: frame?.width ?? 0,
                                      height: frame?.height ?? 0)
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        func moveSheetVertically(to yCoord: CGFloat, removeFromParent: Bool = false) {
            self.view.frame.origin.y = yCoord
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { (_) in
                if removeFromParent {
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
        
        switch recognizer.state {
            case .began, .changed:
                let originY = self.view.frame.minY
                self.view.frame = CGRect(x: 0,
                                         y: originY + translation.y,
                                         width: view.frame.width,
                                         height: view.frame.height)
                UIView.animate(withDuration: 0.05,
                               delay: 0,
                               options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                }

            case .ended, .cancelled:
                if velocity.y < -700 {
                    moveSheetVertically(to: UIScreen.main.bounds.height, removeFromParent: true)
                }
                if velocity.y < -300, self.view.frame.minY < defaultSheetYCoordinate {
                    moveSheetVertically(to: UIScreen.main.bounds.height, removeFromParent: true)
                    return
                }
                if velocity.y < 0, self.view.frame.minY > defaultSheetYCoordinate {
                    moveSheetVertically(to: defaultSheetYCoordinate)
                }
                if velocity.y > 100, self.view.frame.minY != maximumSheetYCoordinate {
                    moveSheetVertically(to: maximumSheetYCoordinate)
                }
            default:
                break
        }
        recognizer.setTranslation(.zero, in: self.view)
//        let translation = recognizer.translation(in: self.view)
//        let y = self.view.frame.minY
//        self.view.frame = CGRect(x: 0,
//                                 y: y + translation.y,
//                                 width: view.frame.width,
//                                 height: view.frame.height)
//        recognizer.setTranslation(.zero, in: self.view)
        
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
