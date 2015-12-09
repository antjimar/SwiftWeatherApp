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
    
    convenience init(dataDictionary: [String: AnyObject], insertIntoManagedObjectContext managedObjectContext: NSManagedObjectContext!) {
        let weatherEntity = NSEntityDescription.entityForName("WeatherEntity", inManagedObjectContext: managedObjectContext)!
        self.init(entity: weatherEntity, insertIntoManagedObjectContext: managedObjectContext)
        
        weatherId = "\(dataDictionary["id"]!)"
        weatherCity = dataDictionary["name"]! as? String
        weatherLatitude = dataDictionary["coord"]!["lat"]! as? NSNumber
        weatherLongitud = dataDictionary["coord"]!["lon"]! as? NSNumber
        weatherTemperature = dataDictionary["main"]!["temp"]! as? NSNumber
        weatherMaxTemperature = dataDictionary["main"]!["temp_max"]! as? NSNumber
        weatherMinTemperature = dataDictionary["main"]!["temp_min"]! as? NSNumber
        weatherDate = NSDate(timeIntervalSince1970: (dataDictionary["dt"]! as? NSTimeInterval)!)
        
    }
}
