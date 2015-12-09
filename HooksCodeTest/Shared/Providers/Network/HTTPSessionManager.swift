//
//  HTTPSessionManager.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import UIKit

class HTTPSessionManager {
    
    static let sharedInstance = HTTPSessionManager()
    var session : NSURLSession!
    
    private init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        configureHeaders(sessionConfig)
        configureCache(sessionConfig)
        session = NSURLSession(configuration: sessionConfig)
    }
    
    private func configureHeaders(sessionConfig:NSURLSessionConfiguration) {
        sessionConfig.HTTPAdditionalHeaders = ["Accept":"application/json", "Accept-Charset": "UTF-8"]
        
    }
    
    private func configureCache(sessionConfig:NSURLSessionConfiguration) {
        let cache = NSURLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        sessionConfig.URLCache = cache
        sessionConfig.requestCachePolicy = .UseProtocolCachePolicy
    }
    
}