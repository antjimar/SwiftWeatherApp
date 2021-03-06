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
    lazy var locationManager = CLLocationManager()
    
    lazy var tableViewManager = WeatherTableViewManager()
    lazy var currentWeatherInteractor = CurrentWeatherInteractor()
    lazy var fiveDaysForecastInteractor = FiveDaysForecastInteractor()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getLocation()
        loadData()
    }
        
    // MARK: - Configuration
    private func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    private func configureNavigationBar() {
        title = "WeatherApp"
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableViewManager.tableView = tableView
    }
    
    private func loadData() {
        if let currentLocation = location {
            currentWeatherInteractor.getCurrentWeatherByLocation(currentLocation, completion: { [weak self] (weatherEntity, error) in
                if error != nil {
                    self!.showAlertViewControllerWithTitle("ERROR", message: "Server Error. Maybe you don have Internet. The data are from the last connection", okButtonText: "OK", cancelButtonText: nil, completion: { ()  in
                    })
                } else {
                    if let currentWeather = weatherEntity {
                        self!.tableViewManager.currentWeather = currentWeather
                        
                        self!.fiveDaysForecastInteractor.getFiveDaysForecastByLocation(self!.location!, completion: { (weatherListEntity, error) in
                            if error != nil {
                                self!.showAlertViewControllerWithTitle("ERROR", message: "Server Error. Maybe you don have Internet. The data are from the last connection", okButtonText: "OK", cancelButtonText: nil, completion: { ()  in
                                })
                            } else {
                                if let weatherList = weatherListEntity {
                                    self!.tableViewManager.fiveDaysForecastArray = weatherList
                                    self!.tableView.reloadData()
                                } else {
                                    self!.showAlertViewControllerWithTitle("ERROR", message: "Server Error. Maybe you don have Internet. The data are from the last connection", okButtonText: "OK", cancelButtonText: nil, completion: { ()  in
                                    })
                                }
                            }
                        })
                    } else {
                        self!.showAlertViewControllerWithTitle("ERROR", message: "Server Error. Maybe you don have Internet. The data are from the last connection", okButtonText: "OK", cancelButtonText: nil, completion: { ()  in
                        })
                    }
                }
                })
        }
    }
    
    private func showAlertViewControllerWithTitle(title: String, message: String, okButtonText: String, cancelButtonText: String?, completion: (Void) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: okButtonText, style: .Default) { (_) in completion() }
        if let cancelText = cancelButtonText {
            let cancel = UIAlertAction(title: cancelText, style: .Cancel) { (_) in completion() }
            alertController.addAction(cancel)
        }
        alertController.addAction(ok)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
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

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.first != nil) {
            location = locations.first
            loadData()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.Denied {
            showAlertViewControllerWithTitle("LOCATION", message: "You have to authorize the access to location", okButtonText: "OK", cancelButtonText: nil, completion: { ()  in
            })
        }
        
        
    }

}
