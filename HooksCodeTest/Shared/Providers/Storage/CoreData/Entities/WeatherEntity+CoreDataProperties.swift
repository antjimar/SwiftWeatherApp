//
//  WeatherEntity+CoreDataProperties.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WeatherEntity {

    @NSManaged var weatherId: String?
    @NSManaged var weatherCity: String?
    @NSManaged var weatherLatitude: NSNumber?
    @NSManaged var weatherLongitud: NSNumber?
    @NSManaged var weatherTemperature: NSNumber?
    @NSManaged var weatherMaxTemperature: NSNumber?
    @NSManaged var weatherMinTemperature: NSNumber?
    @NSManaged var weatherDate: NSDate?
    @NSManaged var weatherType: String?

}
