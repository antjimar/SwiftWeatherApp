//
//  HTTPRequestManagerProtocol.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation

protocol HTTPRequestManagerProtocol {
    
    func GET(URLString: String,
        parameters: [String: String]?,
        currentTask: ((task: NSURLSessionDataTask, responseObject: [String: AnyObject]?) -> Void)?,
        success: ((task: NSURLSessionDataTask, responseObject: [String: AnyObject]?)-> Void)?,
        failure: ((task :NSURLSessionDataTask, error: NSError)-> Void)?)
}