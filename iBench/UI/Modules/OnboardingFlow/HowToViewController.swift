//
//  HowToViewController.swift
//  iBench
//
//  Created by user184905 on 12/15/20.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

class HowToViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var cellsIds = [
        "Welcome Cell",
        "Second Screen",
        "Third Screen"
    ]
    
    private var currentPageIndex = 0 {
        didSet {
            guard oldValue != currentPageIndex else {
                return
            }
            updatePageControllContainerView()
            updateCollectionView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func update() {
        guard isViewLoaded else {
            return
        }
        
        updatePageControllContainerView()
        updateCollectionView()
    }
    
    func updatePageControllContainerView() {
        pageControl.numberOfPages = cellsIds.count
        pageControl.currentPage = currentPageIndex
    }
    
    var handleCollectionViewMovements = true
    func updateCollectionView() {
        handleCollectionViewMovements = false
        let contentOffset = CGPoint(x: collectionView.frame.size.width * CGFloat(currentPageIndex), y: 0)
        collectionView.setContentOffset(contentOffset, animated: true)
    }
    
    @IBAction func skipTap(_ sender: Any) {
        //present authentication screen
    }
    
    @IBAction func nextTap(_ sender: Any) {
        let newPageInde = currentPageIndex + 1
        
        if newPageInde < cellsIds.count {
            currentPageIndex = newPageInde
            return
        }
        
        //present authentication screen
    }
}

extension HowToViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellsIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: cellsIds[indexPath.item], for: indexPath)
    }
    
}

extension HowToViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}

extension HowToViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage()
        handleCollectionViewMovements = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        updateCurrentPage()
        handleCollectionViewMovements = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // cause by user
            updateCurrentPage()
            handleCollectionViewMovements = true
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //caused by code
        updateCurrentPage()
        handleCollectionViewMovements = true
    }
    
    func updateCurrentPage() {
        guard handleCollectionViewMovements else {
            return
        }
        
        guard let visibleCell = collectionView.visibleCells.first,
              let indexPath = collectionView.indexPath(for: visibleCell) else {
            return
        }
        
        currentPageIndex = indexPath.row
    }
}
