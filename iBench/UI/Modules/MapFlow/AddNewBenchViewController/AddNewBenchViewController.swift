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
        UIScreen.main.bounds.height * 0.5 // 50% of screen will be taken by this sheet
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
            let yComponent = self?.defaultSheetYCoordinate ?? 0
            self?.view.frame = CGRect(x: 0,
                                      y: yComponent,
                                      width: frame?.width ?? 0,
                                      height: (frame?.height ?? 0) * 2)
        }
    }
    
    private func moveSheetVertically(to yCoord: CGFloat, speed: CGFloat = 1, removeFromParent: Bool = false) {
        let distance = abs(self.view.frame.origin.y - yCoord)
        let velocity = distance / abs(speed)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: velocity,
                       options: .curveEaseOut) {
            self.view.frame.origin.y = yCoord
        } completion: { (_) in
            if removeFromParent {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        switch recognizer.state {
            case .began, .changed:
                let originY = self.view.frame.minY
                let velocity = abs((originY - translation.y) / velocity.y)
                UIView.animate(withDuration: 0.05,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: velocity,
                               options: .curveEaseOut) {
                    self.view.frame = CGRect(x: 0,
                                             y: originY + translation.y,
                                             width: self.view.frame.width,
                                             height: self.view.frame.height)
                }
            case .ended, .cancelled:
                if velocity.y > 2500 {
                    moveSheetVertically(to: UIScreen.main.bounds.height, speed: velocity.y, removeFromParent: true)
                } else if velocity.y > 1500, self.view.frame.minY < defaultSheetYCoordinate {
                    moveSheetVertically(to: defaultSheetYCoordinate, speed: velocity.y)
                } else if velocity.y > 1200, self.view.frame.minY > defaultSheetYCoordinate {
                    moveSheetVertically(to: UIScreen.main.bounds.height, speed: velocity.y, removeFromParent: true)
                } else if -700..<0 ~= velocity.y || 0...1500 ~= velocity.y {
                    let coord: CGFloat
                    if self.view.frame.minY >= (defaultSheetYCoordinate + maximumSheetYCoordinate) / 2 {
                        coord = defaultSheetYCoordinate
                    } else {
                        coord = maximumSheetYCoordinate
                    }
                    moveSheetVertically(to: coord, speed: velocity.y)
                } else if velocity.y < -700, self.view.frame.minY != maximumSheetYCoordinate {
                    moveSheetVertically(to: maximumSheetYCoordinate, speed: velocity.y)
                } else {
                    print(velocity.y)
                }
            default:
                break
        }
        recognizer.setTranslation(.zero, in: self.view)
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
