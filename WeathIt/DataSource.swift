//
//  DataSource.swift
//  WeathIt
//
//  Created by Niklas Korz on 13/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    
    let dateFormatter = DateFormatter()
    
    var weatherList: [Weather] = []
    
    override init() {
        dateFormatter.dateFormat = "dd.MM.yyyy HH"
    }
    
    func update(weatherList: [Weather]) {
        self.weatherList = weatherList
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        let weather = weatherList[indexPath.row]
        cell.iconImageView.image = weather.icon
        let date = Date(timeIntervalSince1970: TimeInterval(weather.timestamp))
        cell.dateLabel.text = dateFormatter.string(from: date) + " Uhr"
        cell.degreesLabel.text = "\(weather.degrees)°C"
        cell.descriptionLabel.text = weather.description
        
        return cell
    }
    
}
