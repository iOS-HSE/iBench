//
//  NetworkLogging.swift
//  iBench
//
//  Created by Андрей Журавлев on 14.09.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation

final class URLLogger: URLProtocol {
    
    override public class func canInit(with request: URLRequest) -> Bool {
        
        print("? Running request: \(request.httpMethod ?? "") - \(request.url?.absoluteString ?? "")")
        
        // By returning `false`, this URLProtocol will do nothing less than logging.
        return false
    }
}
