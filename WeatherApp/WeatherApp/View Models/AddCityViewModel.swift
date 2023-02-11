//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

struct AddCityViewModel {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=2e677aba940872a08b4bba5ea55568d6&units=metric&q="
    
    func create(city: String) {
        guard let url = URL(string: "\(baseURL)\(city)") else {
            print("Wrong URL")
            return
        }
        
        WebSerivce.load(resource: Resource(url: url)) { weatherResponse in
            <#code#>
        }
    }
}
