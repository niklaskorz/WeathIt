//
//  WeatherLoader.swift
//  WeathIt
//
//  Created by Niklas Korz on 27/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import Foundation
import Alamofire

class WeatherLoader {
    static let shared = WeatherLoader(apiKey: API_KEY)
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    static let weatherUrl = baseUrl + "/weather"
    static let forecastUrl = baseUrl + "/forecast"
    
    let baseParams: [String: String]
    
    init(apiKey: String, lang: String = "de", units: String = "metric") {
        baseParams = [
            "APPID": apiKey,
            "lang": lang,
            "units": units
        ]
    }
    
    func load(location: String) -> DataRequest {
        var params = baseParams
        params["q"] = location
        return Alamofire.request(WeatherLoader.weatherUrl, parameters: params)
    }
    
    func loadForecast(location: String) -> DataRequest {
        var params = baseParams
        params["q"] = location
        return Alamofire.request(WeatherLoader.forecastUrl, parameters: params)
    }
}
