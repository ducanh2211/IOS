//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Đức Anh Trần on 22/12/2022.
//  Copyright © 2022 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    private var number: Double
    
    init(number: Double) {
        self.number = number
    }
    
    mutating func calculate(symbol: String) -> Double? {
        switch symbol {
        case "+/-":
            return number * -1
        case "AC":
            return 0
        case "%":
            return number * 0.01
        default:
            return nil
        }
    }
    
}
