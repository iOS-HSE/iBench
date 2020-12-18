//
//  SignInViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol SettingsRouting {
    func navigateBack(_ completion: (() -> Void)?)
}

protocol SettingsViewModeling: BaseViewModeling {
    var currentUser: UserObject? { get }
    var name: String? { get set }
    
    var didChangeNameSuccessfully: (() -> Void)?  { get set }
    
    func changeName()
}


class SettingsViewController: BaseViewController {

    @IBOutlet weak var nameField: UILabel!
    
    var router: SettingsRouting?
    var viewModel: SettingsViewModeling! {
        didSet {
            viewModel.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
            viewModel.didGetError = { [weak self] message in
                DispatchQueue.main.async { [weak self]  in
                    self?.showErrorAlert(title: "Ошибка", message: message, okHandler: nil)
                }
            }
            viewModel.didChangeNameSuccessfully = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.showMessageAlert(title: "Успешно", message: "Вы успешно сменили имя", okHandler: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func update() {
        nameField.text = viewModel.name
    }
    
    func showUserNameAlert() {
        let ac = UIAlertController(title: "Смена имени", message: "Введите новое имя", preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldEditingChanged(_:)), for: .editingChanged)
        }
        ac.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (_) in
            self.viewModel.changeName()
        }))
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.name = sender.text
    }

}

//extension SettingsViewController: UITextFieldDelegate {
//
//}
