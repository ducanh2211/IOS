//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

struct WeatherResponse: Decodable {
    var main: Weather
    var name: String
}

struct Weather: Decodable {
    var temp: String
    var humidity: String
}
