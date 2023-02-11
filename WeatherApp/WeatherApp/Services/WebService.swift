//
//  WebService.swift
//  WeatherApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

struct Resource {
    var url: URL
    
}

struct WebSerivce {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=2e677aba940872a08b4bba5ea55568d6&units=metric&q=hanoi"
    
    static func load(resource: Resource, completion: @escaping (WeatherResponse?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                fatalError("No data")
            }
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
