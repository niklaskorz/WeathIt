//
//  PickerViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

enum RefreshInterval: Equatable {
    case perMinute(UInt)
    case perHour(UInt)
    
    func toTimeInterval() -> TimeInterval {
        switch self {
        case let .perMinute(minute):
            return TimeInterval(minute * 60)
        case let .perHour(hour):
            return TimeInterval(hour * 60 * 60)
        }
    }
    
    func toString() -> String {
        switch self {
        case let .perMinute(minute):
            if minute == 1 {
                return "Jede Minute"
            }
            return "Alle \(minute) Minuten"
        case let .perHour(hour):
            if hour == 1 {
                return "Jede Stunde"
            }
            return "Alle \(hour) Stunden"
        }
    }
    
    func serialize() -> UInt {
        switch self {
        case let .perMinute(minute):
            return minute
        case let .perHour(hour):
            return hour * 60
        }
    }
    
    static func parse(serialized: UInt) -> RefreshInterval? {
        if serialized % 60 == 0 {
            return .perHour(serialized / 60)
        }
        return .perMinute(serialized)
    }
}

func ==(lhs: RefreshInterval, rhs: RefreshInterval) -> Bool {
    switch (lhs, rhs) {
    case let (.perMinute(a), .perMinute(b)):
        return a == b
    case let (.perHour(a), .perHour(b)):
        return a == b
    default:
        return false
    }
}

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let intervalOptions: [RefreshInterval] = [
        .perMinute(5),
        .perMinute(10),
        .perMinute(30),
        .perHour(1),
        .perHour(2),
        .perHour(5),
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        if let serializedInterval = defaults.object(forKey: "refreshInterval") as? UInt,
            let interval = RefreshInterval.parse(serialized: serializedInterval),
            let index = intervalOptions.index(where: { $0 == interval }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervalOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel()
        view.text = intervalOptions[row].toString()
        view.textAlignment = .center
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        log.info("Selected interval: \(intervalOptions[row].toString())")
        defaults.set(intervalOptions[row].serialize(), forKey: "refreshInterval")
    }
    
}
