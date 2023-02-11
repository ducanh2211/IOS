//
//  APICaller.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import Foundation

struct NetworkConstant {
    static let baseURL = "https://api.themoviedb.org"
    static let API_KEY = "65db6bef59bff99c6a4504f0ce877ade"
    static let imageAddress = "https://image.tmdb.org/t/p/w500"
}

enum APIError: Error {
    case urlError
    case parseError
}

class APICaller {
    
//    static func load(url: URL ,completion: @escaping (  Result<MovieResponse, APIError>) -> Void) {
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            print("DEBUG: load APICaller url")
//            guard let data = data, error == nil else {
//                completion(.failure(.urlError))
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
//                print("DEBUG: load APICaller data")
//                DispatchQueue.main.async {
//                    completion(.success(decodedData))
//                }
//            } catch {
//                completion(.failure(.parseError))
//            }
//        }.resume()
//    }
    
    static func getTrendingMovies(completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(NetworkConstant.baseURL)/3/trending/movie/day?api_key=\(NetworkConstant.API_KEY)") else {
            completion(.failure(.urlError))
            return
        }
        
        print("DEBUG: getTrendingMOvies 1")
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                print("DEBUG: getTrendingMOvies 2")
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }.resume()
    }
    
    static func getTrendingTVs(completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(NetworkConstant.baseURL)/3/trending/tv/day?api_key=\(NetworkConstant.API_KEY)") else {
            completion(.failure(.urlError))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }.resume()
    }
    
    static func getUpcomingMovies(completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(NetworkConstant.baseURL)/3/movie/upcoming?api_key=\(NetworkConstant.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }.resume()
    }
    
    static func getPopular(completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(NetworkConstant.baseURL)/3/movie/popular?api_key=\(NetworkConstant.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }.resume()
    }
    
    static func getTopRated(completion: @escaping (Result<MovieResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(NetworkConstant.baseURL)/3/movie/top_rated?api_key=\(NetworkConstant.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.parseError))
            }
        }.resume()
    }

}
