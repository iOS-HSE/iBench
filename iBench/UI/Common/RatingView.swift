//
//  RatingView.swift
//  iBench
//
//  Created by Андрей Журавлев on 15.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol RatingViewDelegate {
    var starsRating: Int { get set }
}

class RatingView: UIStackView {
    
    var delegate: RatingViewDelegate?
    var starsRating = 0 {
        didSet {
            delegate?.starsRating = self.starsRating
        }
    }
    
    var emptyStarImage = UIImage(named: "star") {
        didSet {
            setNeedsDisplay()
        }
    }
    var filledStarImage = UIImage(named: "star.fill") {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.compactMap { $0 as? UIButton }
        var starTag = 1
        starButtons.forEach { (button) in
            button.setImage(emptyStarImage, for: .normal)
            button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
            button.tag = starTag
            starTag += 1
        }
        setStarsRating(rating: starsRating)
    }
    func setStarsRating(rating:Int){
        self.starsRating = rating
        let stackSubViews = self.subviews.compactMap { $0 as? UIButton }
        stackSubViews.forEach { (button) in
            if button.tag > starsRating {
                button.setImage(emptyStarImage, for: .normal)
                button.tintColor = .black
            }else{
                button.tintColor = .yellow
                button.setImage(filledStarImage, for: .normal)
            }
        }
    }
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
}
