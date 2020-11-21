//
//  BaseViewModel.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

public protocol BaseViewModeling: class {
    var isLoading: Bool { get }
    
    var didChange: (() -> Void)? { get set }
    var didChangeParent: (() -> Void)? { get set }
    var didGetError: ((_ message: String) -> Void)? { get set }
}

public class BaseViewModel: BaseViewModeling {
        
    public var isLoading = false {
        didSet {
            didChange?()
        }
    }
    
    public var didChange: (() -> Void)? {
        didSet {
            didChange?()
        }
    }
    
    public var didGetError: ((_ message: String) -> Void)?
    public var didChangeParent: (() -> Void)?
}
