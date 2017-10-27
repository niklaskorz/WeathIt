//
//  WeatherHeaderView.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class WeatherHeaderView: UIView {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(location: String, weather: Weather) {
        locationLabel.text = location
        degreesLabel.text = "\(weather.degrees)°C"
        descriptionLabel.text = weather.description
        iconImageView.image = UIImage(named: weather.icon)
    }

}
