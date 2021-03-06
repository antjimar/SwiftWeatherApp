//
//  WeatherEntity+CoreDataProperties.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeatherEntity {

    @NSManaged var weatherCity: String?
    @NSManaged var weatherDate: NSDate?
    @NSManaged var weatherLatitude: NSNumber?
    @NSManaged var weatherLongitud: NSNumber?
    @NSManaged var weatherMaxTemperature: NSNumber?
    @NSManaged var weatherMinTemperature: NSNumber?
    @NSManaged var weatherTemperature: NSNumber?
    @NSManaged var weatherType: String?
    @NSManaged var weatherDescription: String?
    @NSManaged var weatherIconURL: NSObject?

}
