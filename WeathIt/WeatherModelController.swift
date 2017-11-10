//
//  WeatherModelController.swift
//  WeathIt
//
//  Created by Niklas Korz on 27/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol WeatherModelSubscriber {
    func weatherDidUpdate(weather: Weather, isNight: Bool, location: String)
    func forecastDidUpdate(forecast: [Weather])
}

class WeatherModelController {
    static let shared = WeatherModelController()
    
    var subscriber: WeatherModelSubscriber?
    
    func loadWeather(location: String) {
        LoadingIndicator.increase()
        
        WeatherLoader.shared.load(location: location).responseJSON { response in
            LoadingIndicator.decrease()
            if let error = response.error {
                log.error(error)
                return
            }
            guard let data = response.data else {
                log.error("No weather data returned by API")
                return
            }
            // SwiftyJSON 4 throws an error when JSON data could not be parsed
            guard let json = try? JSON(data: data) else {
                log.error("JSON weather data could not be parsed")
                return
            }
            
            if json["cod"].intValue == 404 {
                log.info("Location not found")
                return
            }
            guard json["cod"].intValue == 200 else {
                log.error("Weather data could not be loaded: \(json)")
                return
            }
            
            log.info("Weather loaded")
            
            let timestamp = json["dt"].uInt64Value
            let temp = json["main"]["temp"].doubleValue
            let location = json["name"].stringValue
            let weatherData = json["weather"][0]
            let description = weatherData["description"].stringValue
            let icon = weatherData["icon"].stringValue
            
            let weather = Weather(timestamp: timestamp, degrees: Int(temp.rounded()), description: description, icon: icon)
            
            self.subscriber?.weatherDidUpdate(weather: weather, isNight: icon.last == "n", location: location)
        }
    }
    
    func loadForecast(location: String) {
        WeatherLoader.shared.loadForecast(location: location).responseJSON { response in
            LoadingIndicator.decrease()
            if let error = response.error {
                log.error(error)
                return
            }
            guard let data = response.data else {
                log.error("No forecast data returned by API")
                return
            }
            // SwiftyJSON 4 throws an error when JSON data could not be parsed
            guard let json = try? JSON(data: data) else {
                log.error("JSON forecast data could not be parsed")
                return
            }
            
            if json["cod"].intValue == 404 {
                log.error("Location not found")
                return
            }
            guard json["cod"].intValue == 200 else {
                log.error("Forecast data could not be loaded: \(json)")
                return
            }
            
            let weatherList = json["list"].arrayValue.map { (data) -> Weather in
                let timestamp = data["dt"].uInt64Value
                let temp = data["main"]["temp"].doubleValue
                let weatherData = data["weather"][0]
                let description = weatherData["description"].stringValue
                let icon = weatherData["icon"].stringValue
                
                return Weather(timestamp: timestamp, degrees: Int(temp.rounded()), description: description, icon: icon)
            }
            
            self.subscriber?.forecastDidUpdate(forecast: weatherList)
            
            log.info("Forecast loaded with \(weatherList.count) items")
        }
    }
}
