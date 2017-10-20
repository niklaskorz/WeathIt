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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.backgroundColor = backgroundDay
        tableView.backgroundColor = backgroundDay
        
        location = defaults.string(forKey: "location") ?? "Mannheim"
        
        log.info("Location: \(location)")
        
        loadWeather(location: location)
        loadForecast(location: location)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParentViewController {
            log.debug("Going back to search")
            defaults.removeObject(forKey: "location")
        }
    }

    func loadWeather(location: String) {
        LoadingIndicator.increase()
        headerView.isHidden = true
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
                log.debug(json)
                
                if json["cod"].intValue == 404 {
                    log.info("Location not found")
                    return
                }
                
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
                
                self.headerView.isHidden = false
            }
    }
    
    func loadForecast(location: String) {
        LoadingIndicator.increase()
        
        let dataSource = tableView.dataSource as! DataSource
        dataSource.update(weatherList: [])
        tableView.reloadData()
        
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
                
                log.debug(json)
                
                let weatherList = json["list"].arrayValue.map { (data) -> Weather in
                    let timestamp = data["dt"].uInt64Value
                    let temp = data["main"]["temp"].doubleValue
                    let weatherData = data["weather"][0]
                    let description = weatherData["description"].stringValue
                    let iconId = weatherData["icon"].stringValue
                    let icon = UIImage(named: iconId + ".png")
                    
                    return Weather(timestamp: timestamp, degrees: Int(temp.rounded()), description: description, icon: icon)
                }
                
                dataSource.update(weatherList: weatherList)
                self.tableView.reloadData()
        }
    }

}

