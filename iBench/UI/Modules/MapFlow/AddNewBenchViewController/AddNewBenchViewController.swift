//
//  AddNewBenchViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol AddNewBenchRouting {
//    func navigateBack(from: UIViewController, completion: (() -> Void)?)
    func presentBenchInfoViewController(object: BenchObject, _ completion: (() -> Void)?)
}

protocol AddNewBenchViewModeling: BaseViewModeling {
    var coordinates: LocationCoordinates? { get set }
    var benchObject: BenchObject? { get set }
    var comment: String? { get set }
    var rating: Int? { get set }
    
    var isEditingMode: Bool { get }
    
    var didAddBenchSuccessfully: (() -> Void)? { get set }
    
    func addBench()
    func saveBenchChanges()
}

class AddNewBenchViewController: BottomSheetViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var textViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var router: AddNewBenchRouting?
    var viewModel: AddNewBenchViewModeling? {
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
            viewModel?.didAddBenchSuccessfully = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.collapseViewControllerWithoutPan()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        // to initialize default rating
        segmentedControlValueChanged(ratingSegmentedControl)
        setupGestures()
        setupTextView()
        if viewModel?.isEditingMode ?? false {
            setupEditingMode()
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewController(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func setupTextView() {
        commentTextView.text = defaultTextViewPlaceholder
        commentTextView.textColor = .lightGray
        commentTextView.delegate = self
    }
    
    private func setupEditingMode() {
        commentTextView.text = viewModel?.benchObject?.comment
        commentTextView.textColor = .black
        
        ratingSegmentedControl.selectedSegmentIndex = (Int(viewModel?.benchObject?.rating ?? 3) - 1)
        
    }
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateContainerView()
        updateConfirmButton()
    }
    
    private func updateContainerView() {
        let isLoading = viewModel?.isLoading ?? false
        containerView.isHidden = isLoading
        activityIndicator.isActive = isLoading
    }
    
    private func updateConfirmButton() {
        guard let viewModel = viewModel else {
            return
        }
        let imageName = viewModel.isEditingMode ? "checkmark" : "plus"
        confirmButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func addTapped() {
        (viewModel?.isEditingMode ?? false) ? viewModel?.saveBenchChanges() : viewModel?.addBench()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let rating = Int(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "") else {
            return
        }
        viewModel?.rating = rating
    }
}

extension AddNewBenchViewController: BottomSheetBenchesDelegate {
    
    func didUpdateBenchLocation(_ bench: BenchObject) {
        collapseViewControllerWithoutPan {
            self.router?.presentBenchInfoViewController(object: bench, nil)
        }
    }
    
    func didUpdateTapCoordinates(_ coordinates: LocationCoordinates) {
        viewModel?.coordinates = coordinates
    }
    
    func didTapOutside() {
        collapseViewControllerWithoutPan()
    }
    
}

extension AddNewBenchViewController: UITextViewDelegate {
    var defaultTextViewPlaceholder: String {
        "Коментарий"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultTextViewPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = defaultTextViewPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 100 {
            textView.isScrollEnabled = true
        } else {
            textViewHeightAnchor.constant = textView.contentSize.height
            UIView.animate(withDuration: 0.1) {
                textView.layoutIfNeeded()
            }
        }
        viewModel?.comment = textView.text
    }
}

extension AddNewBenchViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y > maximumSheetYCoordinate {
            let diff = abs(self.view.frame.origin.y - maximumSheetYCoordinate)
            super.moveSheetVertically(to: maximumSheetYCoordinate,
                                      speed: diff)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //do nothing
    }
    
}
