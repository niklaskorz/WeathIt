//
//  WeatherViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 13/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, WeatherModelSubscriber {
    
    @IBOutlet weak var headerView: WeatherHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let backgroundDay = UIColor(hue: 0.55, saturation: 0.77, brightness: 0.92, alpha: 1.00)
    let backgroundNight = UIColor(hue: 0.58, saturation: 0.91, brightness: 0.50, alpha: 1.00)
    
    var location = ""
    let defaults = UserDefaults.standard
    
    var modelController: WeatherModelController!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelController = WeatherModelController(subscriber: self)
        
        headerView.backgroundColor = backgroundDay
        tableView.backgroundColor = backgroundDay
        
        location = defaults.string(forKey: "location") ?? "Mannheim" // Mannheim as fallback for debugging
        
        log.info("Location: \(location)")
        
        modelController.loadWeather(location: location)
        modelController.loadForecast(location: location)
        
        setupTimer()
        defaults.addObserver(self, forKeyPath: "refreshInterval", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "refreshInterval" {
            return
        }
        DispatchQueue.main.async {
            self.setupTimer()
        }
    }
    
    func setupTimer() {
        log.debug("Setting up timer")
        let serializedInterval = defaults.object(forKey: "refreshInterval") as? UInt
        var interval: RefreshInterval = .perMinute(5)
        if let si = serializedInterval, let i = RefreshInterval.parse(serialized: si) {
            interval = i
        }
        log.debug("Interval: \(interval.toString())")
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval.toTimeInterval(), repeats: true, block: { _ in
            log.info("Refreshing weather data")
            self.modelController.loadWeather(location: self.location)
            self.modelController.loadForecast(location: self.location)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParentViewController {
            log.debug("Going back to search")
            defaults.removeObject(forKey: "location")
        }
    }

    func weatherDidUpdate(weather: Weather, isNight: Bool, location: String) {
        headerView.update(location: location, weather: weather)
        
        if isNight {
            headerView.backgroundColor = backgroundNight
            view.backgroundColor = backgroundNight
        } else {
            headerView.backgroundColor = backgroundDay
            view.backgroundColor = backgroundDay
        }
    }
    
    func forecastDidUpdate(forecast: [Weather]) {
        let dataSource = tableView.dataSource as! ForecastDataSource
        dataSource.update(forecast: forecast)
        tableView.reloadData()
    }

}

