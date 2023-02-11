//
//  Order.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case suada
    case bacxiu
    case denda
    case Capiii
    case latte
}

enum CoffeeSize: String, Codable, CaseIterable {
    case Small
    case small
    case medium
    case large
}

struct Order: Codable {
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("Wrong URL")
        }
        return Resource<[Order]>(url: url)
    }()
    
    
    var name: String
    var email: String
    var type: CoffeeType
    var size: CoffeeSize
}
