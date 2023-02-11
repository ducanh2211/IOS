//
//  APICaller.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import Foundation

// custom error
enum NetworkError: Error {
    case urlError
    case parseError
    case domainError
}

struct Resource<T: Codable> {
    var url: URL
}

class APICaller {
    static func load<T>(resource: Resource<T>, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            
            // nếu data = nil hoặc error != nil truyền NetworkError vào completion handler
            guard let data = data, error == nil else {
                completionHandler(.failure(.domainError))
                return
            }
            
            // parse data sang type T
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                
                // truyền decodedData(T) vào completion handler
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.parseError))
            }
        }.resume()
    }
}
