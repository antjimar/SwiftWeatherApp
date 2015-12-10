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
    
    func getCurrentWeatherByLocation(location: CLLocation, completion: (data: AnyObject?, error: NSError?) -> Void) {
        
        getCacheDataByType(.Current, completion: completion)
        
        let params = ["lat": "\(location.coordinate.latitude)", "lon": "\(location.coordinate.longitude)", "appid": Constants.APIKey, "units": "metric"]
        
        requestManager.GET("weather", parameters: params, currentTask: nil, success: { (task, responseObject) in
            self.writeManagedObjectContext.performBlock { () in
                let predicate = NSPredicate(format: "%K = %@", "weatherType", WeatherType.Current.rawValue)
                self.removeCacheDataWithPredicate(predicate, context: self.writeManagedObjectContext)
                
                let weatherEntity = WeatherEntity(currentDataWithDictionary: responseObject!, city: nil, latitude: nil, longitude: nil, insertIntoManagedObjectContext: self.writeManagedObjectContext)
                weatherEntity.weatherType = WeatherType.Current.rawValue
                do {
                    try self.writeManagedObjectContext.save()
                } catch let error as NSError {
                    completion(data: nil, error: error)
                }
                let mainThreadWeatherEntity = self.managedObjectContext.objectInManagedObjectContext(weatherEntity)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(data: mainThreadWeatherEntity, error: nil)
                })
            }
            
            }) { (task, error) in
                print(error)
                completion(data: nil, error: error)
        }
    }
    
    func getFiveDaysForecastByLocation(location: CLLocation, completion: (data: AnyObject?, error: NSError?) -> Void) {
        
        getCacheDataByType(.Forecast, completion: completion)
        
        let params = ["lat": "\(location.coordinate.latitude)", "lon": "\(location.coordinate.longitude)", "appid": Constants.APIKey, "units": "metric"]
        
        requestManager.GET("forecast", parameters: params, currentTask: nil, success: { (task, responseObject) in
            
            if let aResponseObject = responseObject {
                let cityNameString = aResponseObject["city"]!["name"]! as? String
                let latitude = aResponseObject["coord"]!["lat"]! as? NSNumber
                let longitude = aResponseObject["coord"]!["long"]! as? NSNumber
                let forecastDictArray = aResponseObject["list"]! as? [AnyObject]
                
                var forecastArray = [WeatherEntity]()
                
                if let aForecastDictArray = forecastDictArray {
                    for (_, element) in aForecastDictArray.enumerate() {
                        let weatherEntity = WeatherEntity(currentDataWithDictionary: element as! [String: AnyObject], city: cityNameString, latitude: latitude, longitude: longitude, insertIntoManagedObjectContext: self.writeManagedObjectContext)
                        weatherEntity.weatherType = WeatherType.Forecast.rawValue
                        forecastArray.append(weatherEntity)
                    }
                    
                    do {
                        try self.writeManagedObjectContext.save()
                    } catch let error as NSError {
                        completion(data: nil, error: error)
                    }
                    
                    var mainThreadForecastArray = [WeatherEntity]()
                    for (_, element) in forecastArray.enumerate() {
                        mainThreadForecastArray.append(self.managedObjectContext.objectInManagedObjectContext(element))
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(data: mainThreadForecastArray, error: nil)
                    })
                    
                } else {
                    // TODO: Error
                    completion(data: nil, error: NSError(domain: "", code: 1, userInfo: nil))
                }
                
            } else {
                // TODO: Error
                completion(data: nil, error: NSError(domain: "", code: 1, userInfo: nil))
            }
            
            }) { (task, error) in
                print(error)
                completion(data: nil, error: error)
        }
    }
    
    //MARK:- Private
    private func getCacheDataByType(weatherType: WeatherType, completion: (data: AnyObject?, error: NSError?) -> Void) {
        managedObjectContext.performBlock { () in
            switch weatherType {
            case .Current:
                let fetchRequest = NSFetchRequest(entityName: "WeatherEntity")
                fetchRequest.predicate = NSPredicate(format: "%K = %@", "weatherType", WeatherType.Current.rawValue)
                do {
                    let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as? [WeatherEntity]
                    completion(data: fetchResults?.first, error: nil)
                } catch let error as NSError {
                    completion(data: nil, error: error)
                }
                
            case .Forecast:
                let fetchRequest = NSFetchRequest(entityName: "WeatherEntity")
                fetchRequest.predicate = NSPredicate(format: "%K = %@", "weatherType", WeatherType.Forecast.rawValue)
                do {
                    let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as? [WeatherEntity]
                    completion(data: fetchResults, error: nil)
                } catch let error as NSError {
                    completion(data: nil, error: error)
                }
            }
        }
    }
    
    private func removeCacheDataWithPredicate(predicate: NSPredicate, context: NSManagedObjectContext) -> Bool {
        var returnValue = false
        let fetchRequest = NSFetchRequest(entityName: "WeatherEntity")
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [WeatherEntity]
            if let results = fetchResults {
                for (_, element) in results.enumerate() {
                    context.deleteObject(element)
                }
            }
            returnValue = true
        } catch let error as NSError {
            print(error)
            returnValue = false
        }
        
        return returnValue
    }
    
}

