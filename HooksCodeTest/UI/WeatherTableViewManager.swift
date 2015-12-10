//
//  WeatherTableViewManager.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import UIKit

class WeatherTableViewManager: NSObject {
    
    var currentWeather: WeatherEntity?
    var fiveDaysForecastArray: [WeatherEntity]?
    
    var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            registerNibs()
        }
    }
    
    func registerNibs() {
        tableView?.registerNib(CurrentWeatherTableViewCell.self)
        tableView?.registerNib(ForecastTableViewCell.self)
    }

}

extension WeatherTableViewManager: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections: Int
        if let aFiveDaysForecastArray = fiveDaysForecastArray {
            numberOfSections = aFiveDaysForecastArray.count + 1
        } else {
            numberOfSections = 0
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSections: Int
        if section == 0 {
            numberOfRowsInSections = 1
        } else {
            numberOfRowsInSections = fiveDaysForecastArray!.count
        }
        return numberOfRowsInSections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            let currentWeatherCell = tableView.dequeueReusableCellWithIdentifier(CurrentWeatherTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! CurrentWeatherTableViewCell
            currentWeatherCell.cityLabel.text = currentWeather?.weatherCity
            currentWeatherCell.maxTempLabel.text = "\((currentWeather?.weatherMaxTemperature)!)ºC"
            currentWeatherCell.minTempLabel.text = "\((currentWeather?.weatherMinTemperature)!)ºC"
            
            // TODO
            currentWeatherCell.iconImageView = nil
            
            currentWeatherCell.descriptionLabel.text = currentWeather?.weatherDescription
            currentWeatherCell.tempLabel.text = "\((currentWeather?.weatherTemperature)!)ºC"
            
            let dateString = NSDateFormatter.localizedStringFromDate((currentWeather?.weatherDate)!, dateStyle: .MediumStyle, timeStyle: .NoStyle)
            
            currentWeatherCell.dateLabel.text = dateString
            
            
            cell = currentWeatherCell
        } else {
            let weatherEntity = fiveDaysForecastArray![indexPath.row]
            let forecastCell = tableView.dequeueReusableCellWithIdentifier(ForecastTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! ForecastTableViewCell
            forecastCell.descriptionLabel.text = weatherEntity.weatherDescription
            forecastCell.maxTempLabel.text = "\((weatherEntity.weatherMaxTemperature)!)ºC"
            forecastCell.minTempLabel.text = "\((weatherEntity.weatherMinTemperature)!)ºC"
            
            // TODO
            forecastCell.iconImageView = nil
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            let time = formatter.stringFromDate(weatherEntity.weatherDate!)
            forecastCell.timeLabel.text = time
            
            cell = forecastCell
        }
        
        
        
        
        
        
        
        
        return cell!
    }
}

