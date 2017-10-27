//
//  DataSource.swift
//  WeathIt
//
//  Created by Niklas Korz on 13/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

// DataSource for the weather forecast table
class ForecastDataSource: NSObject, UITableViewDataSource {
    
    let dateFormatter = DateFormatter()
    
    var weatherList: [Weather] = []
    
    override init() {
        dateFormatter.dateFormat = "dd.MM.yyyy HH"
    }
    
    func update(forecast: [Weather]) {
        weatherList = forecast
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        
        let weather = weatherList[indexPath.row]
        cell.iconImageView.image = UIImage(named: weather.icon)
        let date = Date(timeIntervalSince1970: TimeInterval(weather.timestamp))
        cell.dateLabel.text = dateFormatter.string(from: date) + " Uhr"
        cell.degreesLabel.text = "\(weather.degrees)°C"
        cell.descriptionLabel.text = weather.description
        
        return cell
    }
    
}
