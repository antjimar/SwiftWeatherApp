//
//  FiveDaysForecastInteractor.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import MapKit

class FiveDaysForecastInteractor {
    
    lazy var weatherProvider = WeatherProvider()
    
    func getFiveDaysForecastByLocation(location: CLLocation, completion: (weatherListEntity: [WeatherEntity]?, error: NSError?) -> Void) {
        weatherProvider.getFiveDaysForecastByLocation(location) { (data, error) -> Void in
            if error == nil {
                if let aData = data {
                    let weatherListEntity = aData as! [WeatherEntity]
                    completion(weatherListEntity: weatherListEntity, error: nil)
                } else {
                    // TODO
                    completion(weatherListEntity: nil, error: NSError(domain: "", code: 1, userInfo: nil))
                }
            } else {
                // Error
                completion(weatherListEntity: nil, error: error)
            }
        }
    }
}