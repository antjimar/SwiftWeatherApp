//
//  WeatherEntity.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import CoreData

enum WeatherType: String {
    case Current = "current"
    case Forecast = "forecast"
}

class WeatherEntity: NSManagedObject {
    
    convenience init(currentDataWithDictionary dataDictionary: [String: AnyObject], city: String?, latitude: NSNumber?, longitude: NSNumber?, insertIntoManagedObjectContext managedObjectContext: NSManagedObjectContext!) {
        let weatherEntity = NSEntityDescription.entityForName("WeatherEntity", inManagedObjectContext: managedObjectContext)!
        self.init(entity: weatherEntity, insertIntoManagedObjectContext: managedObjectContext)
        
        if let aCity = city {
            weatherCity = aCity
        } else {
            weatherCity = dataDictionary["name"]! as? String
        }
        
        if let aLatitude = latitude {
            weatherLatitude = aLatitude
        } else {
            weatherLatitude = dataDictionary["coord"]!["lat"]! as? NSNumber
        }
        
        if let aLongitud = longitude {
            weatherLongitud = aLongitud
        } else {
            weatherLongitud = dataDictionary["coord"]!["lon"]! as? NSNumber
        }
        
        weatherTemperature = dataDictionary["main"]!["temp"]! as? NSNumber
        weatherMaxTemperature = dataDictionary["main"]!["temp_max"]! as? NSNumber
        weatherMinTemperature = dataDictionary["main"]!["temp_min"]! as? NSNumber
        weatherDate = NSDate(timeIntervalSince1970: (dataDictionary["dt"]! as? NSTimeInterval)!)
    }
}
