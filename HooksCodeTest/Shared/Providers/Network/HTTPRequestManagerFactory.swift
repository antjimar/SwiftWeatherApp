//
//  HTTPRequestManagerFactory.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation

class HTTPRequestManagerFactory {
    
    class func requestManager(baseURL: String) -> HTTPRequestManagerProtocol {
        return HTTPRequestManager(baseURL: baseURL)
    }
}
