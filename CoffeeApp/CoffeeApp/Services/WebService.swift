//
//  WebService.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import Foundation

enum NetworkError: Error {
    case domainError
    case urlError
    case decodingError
}

struct Resource<T: Codable> {
    var url: URL
}

struct WebService {
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(decodedData))
                }
            } catch {
                completion(Result.failure(.decodingError))
            }
        }.resume()
    }
}
