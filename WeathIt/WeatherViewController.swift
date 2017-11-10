//
//  WeatherViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 13/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, WeatherModelSubscriber, SettingsControllerDelegate {
    
    @IBOutlet weak var headerView: WeatherHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let backgroundDay = UIColor(hue: 0.55, saturation: 0.77, brightness: 0.92, alpha: 1.00)
    let backgroundNight = UIColor(hue: 0.58, saturation: 0.91, brightness: 0.50, alpha: 1.00)
    
    let defaults = UserDefaults.standard
    
    let modelController = WeatherModelController.shared
    let settingsController = SettingsController.shared
    
    var location: String?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelController.subscriber = self
        settingsController.delegate = self
        
        headerView.backgroundColor = backgroundDay
        tableView.backgroundColor = backgroundDay
        
        if let location = SettingsController.shared.location {
            self.location = location
            log.info("Location: \(location)")
            modelController.loadWeather(location: location)
            modelController.loadForecast(location: location)
            setupTimer()
        } else {
            performSegue(withIdentifier: "locationSegue", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParentViewController {
            log.debug("Going back to search")
            defaults.removeObject(forKey: "location")
        }
    }
    
    func setupTimer() {
        log.debug("Setting up timer")
        let interval = settingsController.refreshInterval
        log.debug("Interval: \(interval.toString())")
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval.toTimeInterval(), repeats: true, block: self.scheduledUpdate)
    }
    
    func scheduledUpdate(timer: Timer) {
        if let location = location {
            log.info("Refreshing weather data")
            modelController.loadWeather(location: location)
            modelController.loadForecast(location: location)
        }
    }
    
    func locationDidChange(location: String?) {
        if let location = location {
            self.location = location
            log.info("Location: \(location)")
            modelController.loadWeather(location: location)
            modelController.loadForecast(location: location)
        }
    }
    
    func refreshIntervalDidChange(refreshInterval: RefreshInterval) {
        setupTimer()
    }

    func weatherDidUpdate(weather: Weather, isNight: Bool, location: String) {
        headerView.update(location: location, weather: weather)
        
        if isNight {
            headerView.backgroundColor = backgroundNight
            tableView.backgroundColor = backgroundNight
        } else {
            headerView.backgroundColor = backgroundDay
            tableView.backgroundColor = backgroundDay
        }
    }
    
    func forecastDidUpdate(forecast: [Weather]) {
        let dataSource = tableView.dataSource as! ForecastDataSource
        dataSource.update(forecast: forecast)
        tableView.reloadData()
    }
}

