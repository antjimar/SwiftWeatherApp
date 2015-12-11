//
//  WeatherTableViewManager.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import UIKit
import Haneke

class WeatherTableViewManager: NSObject {
    
    var currentWeather: WeatherEntity?
    var fiveDaysForecastArray: [WeatherEntity]? {
        didSet {
            createForecastDictionary()
        }
    }
    
    var fiveDaysForecastKeys = [NSDate]()
    var fiveDaysForecastValues = [[WeatherEntity]]()
    
    var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            registerNibs()
        }
    }
    
    private func registerNibs() {
        tableView?.registerNib(CurrentWeatherTableViewCell.self)
        tableView?.registerNib(ForecastTableViewCell.self)
    }
    
    private func createForecastDictionary() {
        if let aFiveDaysForecastArray = fiveDaysForecastArray {            
            var auxFiveDaysForecastDictionary = [NSDate: [WeatherEntity]]()
            for (_, element) in aFiveDaysForecastArray.enumerate() {
                let dateKey = getNSDateWithCeroTime(element.weatherDate!)
                var weatherArray = auxFiveDaysForecastDictionary[dateKey]
                if weatherArray != nil {
                    weatherArray!.append(element)
                } else {
                    weatherArray = [element]
                }
                auxFiveDaysForecastDictionary.updateValue(weatherArray!, forKey: dateKey)
            }
            
            let sortedKeysAndValues = auxFiveDaysForecastDictionary.sort { $0.0.timeIntervalSince1970 < $1.0.timeIntervalSince1970 }
            fiveDaysForecastKeys.removeAll()
            fiveDaysForecastValues.removeAll()
            fiveDaysForecastKeys = sortedKeysAndValues.map {$0.0 }
            fiveDaysForecastValues = sortedKeysAndValues.map {$0.1 }
        }
        
    }
    
    private func getNSDateWithCeroTime(date: NSDate) -> NSDate {
        let timeInterval = floor(date.timeIntervalSince1970 / 86400) * 86400
        return NSDate(timeIntervalSince1970: timeInterval)
    }
}

extension WeatherTableViewManager: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 0
        if let _ = currentWeather {
            numberOfSections = fiveDaysForecastKeys.count + 1
        }
        
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSections: Int?
        if section == 0 {
            numberOfRowsInSections = 1
        } else {
            numberOfRowsInSections = fiveDaysForecastValues[section - 1].count
        }
        return numberOfRowsInSections!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            let currentWeatherCell = tableView.dequeueReusableCellWithIdentifier(CurrentWeatherTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! CurrentWeatherTableViewCell
            currentWeatherCell.cityLabel.text = currentWeather?.weatherCity
            
            let maxTempString = String.localizedStringWithFormat("%.0f", Double((currentWeather?.weatherMaxTemperature)!))
            currentWeatherCell.maxTempLabel.text = "\(maxTempString)ºC"
            
            let minTempString = String.localizedStringWithFormat("%.0f", Double((currentWeather?.weatherMinTemperature)!))
            currentWeatherCell.minTempLabel.text = "\(minTempString)ºC"
            currentWeatherCell.iconImageView.hnk_setImageFromURL(currentWeather?.weatherIconURL as! NSURL, placeholder: nil, format: nil, failure: nil, success: nil)
            
            currentWeatherCell.descriptionLabel.text = currentWeather?.weatherDescription?.uppercaseString
            currentWeatherCell.tempLabel.text = "\((currentWeather?.weatherTemperature)!)ºC"
            
            let dateString = NSDateFormatter.localizedStringFromDate((currentWeather?.weatherDate)!, dateStyle: .MediumStyle, timeStyle: .NoStyle)
            
            currentWeatherCell.dateLabel.text = dateString
            
            cell = currentWeatherCell
            
        } else {
            let weatherEntity = fiveDaysForecastValues[indexPath.section - 1][indexPath.row]
            
            let forecastCell = tableView.dequeueReusableCellWithIdentifier(ForecastTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! ForecastTableViewCell
            forecastCell.descriptionLabel.text = weatherEntity.weatherDescription?.uppercaseString
            
            let maxTempString = String.localizedStringWithFormat("%.2f", Double((weatherEntity.weatherMaxTemperature)!))
            forecastCell.maxTempLabel.text = "\(maxTempString)ºC"
            
            let minTempString = String.localizedStringWithFormat("%.2f", Double((weatherEntity.weatherMinTemperature)!))
            forecastCell.minTempLabel.text = "\(minTempString)ºC"
            
            forecastCell.iconImageView.hnk_setImageFromURL(weatherEntity.weatherIconURL as! NSURL, placeholder: nil, format: nil, failure: nil, success: nil)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            forecastCell.timeLabel.text = formatter.stringFromDate(weatherEntity.weatherDate!)
            
            if fiveDaysForecastValues[indexPath.section - 1].count == indexPath.row + 1 {
                forecastCell.bottomSeparatorCellView.hidden = true
            } else {
                forecastCell.bottomSeparatorCellView.hidden = false
            }
            
            cell = forecastCell
        }
        
        return cell!
    }
}

