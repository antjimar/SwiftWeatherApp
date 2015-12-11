//
//  CurrentWeatherInteractor.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import MapKit

class CurrentWeatherInteractor {
    
    lazy var weatherProvider = WeatherProvider()
    
    func getCurrentWeatherByLocation(location: CLLocation, completion: (weatherEntity: WeatherEntity?, error: NSError?) -> Void) {
        weatherProvider.getCurrentWeatherByLocation(location) { (data, error) in
            if error == nil {
                if let aData = data {
                    let weatherEnity = aData as! WeatherEntity
                    completion(weatherEntity: weatherEnity, error: nil)
                }
            } else {
                completion(weatherEntity: nil, error: error)
            }
        }
    }
}