//
//  PickerViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let intervalOptions: [(String, TimeInterval)] = [
        ("Alle 10 Minuten", 0),
        ("Alle 30 Minuten", 0),
        ("Jede Stunde", 0),
        ("Alle zwei Stunden", 0),
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervalOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel()
        view.text = intervalOptions[row].0
        view.textAlignment = .center
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        log.info("Selected interval: \(intervalOptions[row])")
    }
    
}
