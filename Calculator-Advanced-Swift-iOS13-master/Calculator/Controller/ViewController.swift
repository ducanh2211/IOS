//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    private var isFinishedTyping: Bool = true
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
   
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedTyping = true
       
        if let calcMethod = sender.currentTitle {
            var calculator = CalculatorLogic(number: displayValue)
            guard let result = calculator.calculate(symbol: calcMethod) else {
                fatalError("Cannot convert")
            }
            displayValue = result
        }
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if isFinishedTyping {
                displayLabel.text = numValue
                isFinishedTyping = false
            } else {
                if numValue == "." && displayLabel.text!.contains(".") {
                    return
                }
                displayLabel.text?.append(numValue)
            }
        }
        print(displayLabel.text!)
    }

}

