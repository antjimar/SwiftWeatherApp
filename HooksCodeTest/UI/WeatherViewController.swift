//
//  WeatherViewController.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var location: CLLocation?
    
    lazy var tableViewManager = WeatherTableViewManager()
    lazy var currentWeatherInteractor = CurrentWeatherInteractor()
    lazy var fiveDaysForecastInteractor = FiveDaysForecastInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configuration
    private func getLocation() {
        // TODO
        location = CLLocation(latitude: 39.286836, longitude: -1.471564)
    }
    
    private func configureNavigationBar() {
        title = "WeatherApp"
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableViewManager.tableView = tableView
    }
    
    private func loadData() {
        currentWeatherInteractor.getCurrentWeatherByLocation(location!, completion: { [weak self] (weatherEntity, error) in
            if error != nil {
                // TODO Show alert
            } else {
                if let currentWeather = weatherEntity {
                    self!.tableViewManager.currentWeather = currentWeather
                    
                    self!.fiveDaysForecastInteractor.getFiveDaysForecastByLocation(self!.location!, completion: { (weatherListEntity, error) in
                        if error != nil {
                            // TODO show alert
                            
                        } else {
                            if let weatherList = weatherListEntity {
                                self!.tableViewManager.fiveDaysForecastArray = weatherList
                                self!.tableView.reloadData()
                            } else {
                                // TODO show alert
                            }
                        }
                    })
                } else {
                    // TODO show alert
                }
            }
        })
        
        
        
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat?
        if indexPath.section == 0 {
            height = CurrentWeatherTableViewCell.cellHeight()
        } else {
            height = ForecastTableViewCell.cellHeight()
        }
        return height!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat?
        if section == 0 {
            height = 1.0
        } else {
            height = 40.0
        }
        return height!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: UIView?
        if section != 0 {
            view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40.0))
            view?.backgroundColor = UIColor(red: 216/256, green: 216/256, blue: 216/256, alpha: 1.0)
            
            let sectionLabel = UILabel()
            sectionLabel.font = UIFont.boldSystemFontOfSize(15)
            sectionLabel.textColor = UIColor.blackColor()
            
            let dateString = NSDateFormatter.localizedStringFromDate(tableViewManager.fiveDaysForecastKeys[section - 1], dateStyle: .MediumStyle, timeStyle: .NoStyle)
            sectionLabel.text = dateString
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view!.addSubview(sectionLabel)
            
            let sectionLabelLeadingContraint = NSLayoutConstraint(item: sectionLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20)
            view!.addConstraint(sectionLabelLeadingContraint)
            
            let sectionLabelCentrerYContraint = NSLayoutConstraint(item: sectionLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
            view!.addConstraint(sectionLabelCentrerYContraint)
            
            view!.layoutIfNeeded()
        }
        
        return view
    }
}
