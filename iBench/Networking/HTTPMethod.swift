//
//  HTTPMethod.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
