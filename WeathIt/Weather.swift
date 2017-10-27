//
//  Weather.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import Foundation

struct Weather {
    let timestamp: UInt64
    let degrees: Int
    let description: String
    let icon: String // Identifier for the weather icon, see OpenWeatherMap API for a list
}
