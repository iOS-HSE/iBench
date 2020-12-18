//
//  SearchViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 17.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol SearchRouting {
    func navigateBack(from vc: UIViewController, _ completion: (() -> Void)?)
}

protocol SearchDelegate: class {
    func didsSelectBenchObject(object: BenchObject)
}

protocol SearchViewModeling: BaseViewModeling {
    var numberOfRows: Int { get }
    var distance: Double { get set }
    var isPreciseLocationAvailable: Bool { get }
    
    
    func getBench(at indexPath: IndexPath) -> BenchObject?
    func getDistanceTo(bench: BenchObject) -> Double?
}

class SearchViewController: BaseViewController {
        
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preciseLocationMessageContainerView: UIView!
    
    weak var delegate: SearchDelegate?
    var router: SearchRouting?
    var viewModel: SearchViewModeling? {
        didSet {
            viewModel?.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
            viewModel?.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(title: "Ошбика", message: message, okHandler: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        setup()
    }
    
    private func setup() {
        setupTableView()
        setupSlider()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    private func setupSlider() {
        distanceSlider.maximumValue = 500
        distanceSlider.minimumValue = 50
        distanceSlider.value = 100
    }
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.isHidden = false
            view.addSubview(navBar)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        updateTableView()
        updatePreciseLocationMessageContainerView()
        updateDistanceLabel()
    }
    
    private func updateTableView() {
        guard let viewModel = viewModel else {
            return
        }
        if viewModel.isPreciseLocationAvailable {
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            tableView.isHidden = true
        }
    }
    
    private func updatePreciseLocationMessageContainerView() {
        preciseLocationMessageContainerView.isHidden = viewModel?.isPreciseLocationAvailable ?? true
    }
    
    private func updateDistanceLabel() {
        guard let viewModel = viewModel else {
            return
        }
        distanceLabel.text = String(format: "%d м", Int(viewModel.distance))
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        viewModel?.distance = Double(sender.value)
    }
    
    @objc func backButtonTapped() {
        router?.navigateBack(from: self, nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchTableViewCell else {
            return
        }
        guard let bench = viewModel?.getBench(at: indexPath) else {
            return
        }
        
        let ratingText: String
        if let rating = bench.rating {
            ratingText = "Рейтинг: \(Int(rating))"
        } else {
            ratingText = "Нет рейитнга"
        }
        cell.ratingLabel.text = ratingText
        
        if let distance = viewModel?.getDistanceTo(bench: bench) {
            cell.authorLabel.text = "Расстояние: \(String(format: "%d", Int(distance))) метров"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let benchObject = viewModel?.getBench(at: indexPath) else {
            return
        }
        router?.navigateBack(from: self, {
            self.delegate?.didsSelectBenchObject(object: benchObject)
        })
    }
}
