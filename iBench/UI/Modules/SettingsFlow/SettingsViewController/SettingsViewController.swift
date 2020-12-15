//
//  SignInViewController.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import UIKit

protocol SettingsViewModeling: BaseViewModeling {
    var name: String? { get set }
}


class SettingsViewController: BaseViewController {

    @IBOutlet weak var nameField: UILabel!
    
    var viewModel: SettingsViewModeling! {
        didSet {}
    }

}
