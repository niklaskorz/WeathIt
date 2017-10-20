//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit
import Alamofire
import SwiftyJSON

PlaygroundPage.current.needsIndefiniteExecution = true

Alamofire
    .request(
        "https://api.openweathermap.org/data/2.5/weather",
        parameters: [
            "APPID": API_KEY,
            "lang": "de",
            "units": "metric",
            "type": "accurate",
            "q": "Mannheim"
        ]
    )
    .responseJSON { response in
        if let error = response.error {
            debugPrint(error)
        }
        guard let data = response.data else {
            return
        }
        let json = JSON(data: data)
        debugPrint(json)
        
        let temp = json["main"]["temp"].doubleValue
        let weatherDescription = json["weather"][0]["description"].stringValue
        let iconId = json["weather"][0]["icon"].stringValue
        let icon = UIImage(named: iconId + ".png")
    }
