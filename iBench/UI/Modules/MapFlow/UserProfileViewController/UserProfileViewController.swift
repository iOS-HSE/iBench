//
//  UserProfileViewController.swift
//  iBench
//
//  Created by Hacker Man on 17.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol UserProfileRouting {
    func navigateBack(from vc: UIViewController, _ completion: (() -> Void)?)
    func presentAuthenticateViewController(_ completion: (() -> Void)?)
}

protocol UserProfileViewModeling: BaseViewModeling {
    var userName: String { get }
    var addedBenchesCount: Int { get }
    var commentsLeftCount: Int { get }
    func logout(_ completion: ((String?) -> Void)?)
}

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addedBenchesLabel: UILabel!
    @IBOutlet weak var leftCommentsLabel: UILabel!
    
    var router: UserProfileRouting?
    var viewModel: UserProfileViewModeling? {
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
    
    private func update() {
        guard isViewLoaded else {
            return
        }
        usernameLabel.text = viewModel?.userName
        addedBenchesLabel.text = "Добавлено лавочек: \(viewModel?.addedBenchesCount ?? 0)"
        leftCommentsLabel.text = "Оставлено комментариев: \(viewModel?.commentsLeftCount ?? 0)"
    }
    
    @IBAction func changeUserTapped() {
        viewModel?.logout{ [weak self] (error) in
            guard let self = self else {
                return
            }
            if let error = error {
                self.showErrorAlert(title: "Ошибка", message: error, okHandler: nil)
                return
            }
            self.router?.presentAuthenticateViewController(nil)
        }
    }
    
    @IBAction func backTapped() {
        router?.navigateBack(from: self, nil)
    }
}
