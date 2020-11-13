//
//  Property.swift
//  iBench
//
//  Created by Андрей Журавлев on 13.11.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

public typealias PropertySubscriptionToken = Int

public class Property<T> {
    
    public typealias Listener = (T) -> Void
    
    public var value: T {
        didSet {
            listeners.values.forEach {
                $0(value)
            }
        }
    }
    
    private var listeners = [PropertySubscriptionToken: Listener]()
    
    public init(_ value: T) {
        self.value = value
    }
    
    /// method is not thread safe!
    @discardableResult
    public func addListener(skipCurrent: Bool = false, _ listener: @escaping Listener) -> PropertySubscriptionToken {
        let key = (listeners.keys.max() ?? 0) + 1
        listeners[key] = listener
        if !skipCurrent {
            listener(value)
        }
        return key
    }
    
    /// method is not thread safe!
    public func removeListener(_ token: PropertySubscriptionToken) {
        listeners[token] = nil
    }
}
