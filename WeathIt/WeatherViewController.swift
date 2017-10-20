//
//  WeatherViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 13/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var headerView: WeatherHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let backgroundDay = UIColor(hue: 0.55, saturation: 0.77, brightness: 0.92, alpha: 1.00)
    let backgroundNight = UIColor(hue: 0.58, saturation: 0.91, brightness: 0.50, alpha: 1.00)
    
    var location = ""
    let defaults = UserDefaults.standard
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.backgroundColor = backgroundDay
        tableView.backgroundColor = backgroundDay
        
        location = defaults.string(forKey: "location") ?? "Mannheim"
        
        log.info("Location: \(location)")
        
        loadWeather(location: location)
        loadForecast(location: location)
        
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
            self.loadWeather(location: self.location)
            self.loadForecast(location: self.location)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParentViewController {
            log.debug("Going back to search")
            defaults.removeObject(forKey: "location")
        }
    }

    func loadWeather(location: String) {
        LoadingIndicator.increase()

        Alamofire
            .request(
                "https://api.openweathermap.org/data/2.5/weather",
                parameters: [
                    "APPID": API_KEY,
                    "lang": "de",
                    "units": "metric",
                    // "type": "accurate",
                    "q": location
                ]
            )
            .responseJSON { response in
                LoadingIndicator.decrease()
                if let error = response.error {
                    log.error(error)
                }
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                //log.debug(json)
                
                if json["cod"].intValue == 404 {
                    log.info("Location not found")
                    return
                }
                
                log.info("Weather loaded")
                
                let timestamp = json["dt"].uInt64Value
                let temp = json["main"]["temp"].doubleValue
                let location = json["name"].stringValue
                let weatherData = json["weather"][0]
                let description = weatherData["description"].stringValue
                let iconId = weatherData["icon"].stringValue
                let icon = UIImage(named: iconId + ".png")
                
                let weather = Weather(timestamp: timestamp, degrees: Int(temp.rounded()), description: description, icon: icon)
                
                self.headerView.update(location: location, weather: weather)
                
                if iconId.last == "n" {
                    self.headerView.backgroundColor = self.backgroundNight
                    self.view.backgroundColor = self.backgroundNight
                } else {
                    self.headerView.backgroundColor = self.backgroundDay
                    self.view.backgroundColor = self.backgroundDay
                }
            }
    }
    
    func loadForecast(location: String) {
        LoadingIndicator.increase()
        let dataSource = tableView.dataSource as! DataSource
        Alamofire
            .request(
                "https://api.openweathermap.org/data/2.5/forecast",
                parameters: [
                    "APPID": API_KEY,
                    "lang": "de",
                    "units": "metric",
                    "q": location
                ]
            )
            .responseJSON { response in
                LoadingIndicator.decrease()
                if let error = response.error {
                    log.error(error)
                }
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                
                if json["cod"].intValue == 404 {
                    log.info("Location not found")
                    return
                }
                
                // log.debug(json)
                
                let weatherList = json["list"].arrayValue.map { (data) -> Weather in
                    let timestamp = data["dt"].uInt64Value
                    let temp = data["main"]["temp"].doubleValue
                    let weatherData = data["weather"][0]
                    let description = weatherData["description"].stringValue
                    let iconId = weatherData["icon"].stringValue
                    let icon = UIImage(named: iconId + ".png")
                    
                    return Weather(timestamp: timestamp, degrees: Int(temp.rounded()), description: description, icon: icon)
                }
                
                log.info("Forecast loaded with \(weatherList.count) items")
                
                dataSource.update(weatherList: weatherList)
                self.tableView.reloadData()
        }
    }

}

