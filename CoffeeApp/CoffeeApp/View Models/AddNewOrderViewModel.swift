//
//  AddNewOrderViewModel.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

struct AddNewOrderViewModel {
    var name: String?
    var email: String?
    var selectedType: String?
    var selectedSize: String?
    var type: [String] {
        return CoffeeType.allCases.map { coffeeTypes in
            return coffeeTypes.rawValue.capitalized
        }
    }
    var size: [String] {
        return CoffeeSize.allCases.map { coffeeSizes in
            return coffeeSizes.rawValue.capitalized
        }
    }
}
