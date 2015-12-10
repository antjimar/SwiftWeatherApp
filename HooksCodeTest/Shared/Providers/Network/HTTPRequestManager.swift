//
//  HTTPRequestManager.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation

extension String {
    var escaped: String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}

struct HTTPRequestManagerNotification {
    static let requestStartedNotification = "HTTPRequestManagerNotificationRequestStartedNotification"
    static let requestFinishedNotification = "HTTPRequestManagerNotificationRequestFinishedNotification"
}

class HTTPRequestManager: HTTPRequestManagerProtocol {
    
    let baseURL: String
    static let errorDomain = "com.HTTPRequestManager.error"
    lazy var sessionManager = HTTPSessionManager.sharedInstance
    lazy var notificationCenter = NSNotificationCenter.defaultCenter()
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func GET(URLString: String,
        parameters: [String: String]?,
        currentTask: ((task: NSURLSessionDataTask, responseObject: [String: AnyObject]?) -> Void)?,
        success: ((task: NSURLSessionDataTask, responseObject: [String: AnyObject]?)-> Void)?,
        failure: ((task :NSURLSessionDataTask, error: NSError)-> Void)?) {
            
            let absURL = absoluteURL(URLString, parameters: parameters)
            assert(absURL != nil, "Cannot create request without URL!")
            let request = NSMutableURLRequest(URL: absURL!)
            request.HTTPMethod = "GET"
            
            requestStartedNotification()
            
            var taskRequest: NSURLSessionDataTask?
            taskRequest = sessionManager.session.dataTaskWithRequest(request) { (responseData, urlResponse, error) in
                if let error = error {
                    failure?(task: taskRequest!, error: error)
                } else {
                    self.requestFinishedNotification()
                    let response = urlResponse as! NSHTTPURLResponse
                    if responseData != nil {
                        do {
                            let object = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                            success?(task: taskRequest!, responseObject: object)
                        } catch let error as NSError {
                            print(error)
                            failure?(task: taskRequest!, error: error)
                        } catch {
                            let error: NSError = NSError(domain: HTTPRequestManager.errorDomain, code: response.statusCode, userInfo: nil)
                            print(error)
                            failure?(task: taskRequest!, error: error)
                        }
                    } else {
                        print(error)
                        failure?(task: taskRequest!, error: error!)
                    }
                }
            }
            taskRequest!.resume()
    }
    
    private func absoluteURL(relativeURL: String, parameters : [String: String]?) -> NSURL? {
        var returnURL = "\(baseURL)/\(relativeURL)"
        if let params = urlEncodedParams(parameters) {
            returnURL += "?\(params)"
        }
        return NSURL(string: returnURL)
    }
    
    private func urlEncodedParams(parameters: [String: String]?) -> String? {
        if parameters != nil {
            let retParams = parameters!.map { ("\(($0.0).escaped!)=\(($0.1).escaped!)") }
            return retParams.joinWithSeparator("&")
        }
        return nil
    }
    
    private func requestStartedNotification() {
        dispatch_async(dispatch_get_main_queue()) {
            self.notificationCenter.postNotification(NSNotification(name: HTTPRequestManagerNotification.requestStartedNotification, object: nil, userInfo: nil))
        }
    }
    
    private func requestFinishedNotification() {
        dispatch_async(dispatch_get_main_queue()) {
            self.notificationCenter.postNotification(NSNotification(name: HTTPRequestManagerNotification.requestFinishedNotification, object: nil, userInfo: nil))
        }
    }
    
}