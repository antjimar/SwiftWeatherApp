//
//  WeatherProvider.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class WeatherProvider {
    
    lazy var managedObjectContext: NSManagedObjectContext = CoreDataContextManager.sharedInstance.managedObjectContext!
    lazy var writeManagedObjectContext: NSManagedObjectContext = CoreDataContextManager.sharedInstance.writeManagedObjectContext!
    lazy var requestManager: HTTPRequestManagerProtocol = HTTPRequestManagerFactory.requestManager("\(Constants.APIBaseURL)/\(Constants.APIVersion)")
    
    func getCurrentWeatherByLocation(location: CLLocation, completion: (dataEntity: WeatherEntity?, error: NSError?) -> Void) {
        
        let params = ["lat": "\(location.coordinate.latitude)", "lon": "\(location.coordinate.longitude)", "appid": Constants.APIKey, "units": "metric"]
        
        requestManager.GET("weather", parameters: params, currentTask: nil, success: { (task, responseObject) in
                self.writeManagedObjectContext.performBlock { () in
                    let weatherEntity = WeatherEntity(dataDictionary: responseObject!, insertIntoManagedObjectContext: self.writeManagedObjectContext)
                    weatherEntity.weatherType = WeatherType.Current.rawValue
                    do {
                        try self.writeManagedObjectContext.save()
                    } catch let error as NSError {
                        completion(dataEntity: nil, error: error)
                    }
                    let dataEntityRead = self.managedObjectContext.objectInManagedObjectContext(weatherEntity) 
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(dataEntity: dataEntityRead, error: nil)
                    })
                }
                
            }) { (task, error) in
                print(error)
                completion(dataEntity: nil, error: error)
        }
    }
    
}
