//
//  NetworkConstant.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import Foundation

struct NetworkConstant {
    public static var shared: NetworkConstant = NetworkConstant()
    
    private init() {}
    
    public var domainAddress: String {
        get {
            return "https://api.themoviedb.org/3"
        }
    }
    
    public var pathAddress: String {
        get {
            return "/trending/movie/week"
        }
    }
    
    public var queryAddress: String {
        get {
            return "?api_key=65db6bef59bff99c6a4504f0ce877ade"
        }
    }
    
    public var imageServerAddress: String {
        get {
            return "https://image.tmdb.org/t/p/w500"
        }
    }
}
