//
//  MovieViewModel.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import Foundation
import UIKit

enum Section: Int {
    case TrendingMovies, TrendingTV, Popular, UpcomingMovies, TopRated
}

class MovieListViewModel {
    let sectionTitle = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    var cellData: TableViewCellViewModel?
    var dataSource: MovieResponse?
    
}

extension MovieListViewModel {
    var numberOfSections: Int {
        return self.sectionTitle.count
    }
    
    var numberOfRowsInSection: Int {
        return 1
    }
    
    func getTitleForHeader(in section: Int) -> String {
        return self.sectionTitle[section]
    }
    
    func getData(at indexPath: IndexPath, completion: @escaping (Result<TableViewCellViewModel, Error>) -> Void) {
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:

            APICaller.getTrendingMovies { [weak self] results in
                guard let strongSelf = self else { return }
                
                switch results {
                case .success(let movieResponse):
                    strongSelf.dataSource = movieResponse
                    strongSelf.mapCellData()
                    completion(.success(strongSelf.cellData!))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
            
        case Section.TrendingTV.rawValue:

            APICaller.getTrendingTVs { [weak self] results in
                guard let strongSelf = self else { return }
                
                switch results {
                case .success(let movieResponse):
                    self?.dataSource = movieResponse
                    self?.mapCellData()
                    completion(.success(strongSelf.cellData!))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
            
        case Section.Popular.rawValue:

            APICaller.getPopular { [weak self] results in
                guard let strongSelf = self else { return }
                
                switch results {
                case .success(let movieResponse):
                    self?.dataSource = movieResponse
                    self?.mapCellData()
                    completion(.success(strongSelf.cellData!))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
            
        case Section.UpcomingMovies.rawValue:

            APICaller.getUpcomingMovies { [weak self] results in
                guard let strongSelf = self else { return }
                
                switch results {
                case .success(let movieResponse):
                    self?.dataSource = movieResponse
                    self?.mapCellData()
                    completion(.success(strongSelf.cellData!))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
            
        case Section.TopRated.rawValue:

            APICaller.getTopRated { [weak self] results in
                guard let strongSelf = self else { return }
                
                switch results {
                case .success(let movieResponse):
                    self?.dataSource = movieResponse
                    self?.mapCellData()
                    completion(.success(strongSelf.cellData!))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
        default:
            break
        }
      
    }
    
    func mapCellData() {
        guard let movies = self.dataSource?.results else { return }
        self.cellData = TableViewCellViewModel(movies: movies)
    }
    
}
