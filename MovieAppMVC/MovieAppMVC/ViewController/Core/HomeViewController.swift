//
//  HomeViewController.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        setupTableView()
        loadMovie()
    }
    
    func configView() {
        self.title = "Home"
    }
}

// MARK: - Handle API
extension HomeViewController {
    
    func loadMovie() {
        let urlString = NetworkConstant.shared.domainAddress + NetworkConstant.shared.pathAddress + NetworkConstant.shared.queryAddress
        guard let url = URL(string: urlString) else {
            fatalError("urlError")
        }
        let resource = Resource<MovieModel>(url: url)
        
        APICaller.load(resource: resource) { result in
            switch result {
            case .success(let movieModel):
                self.movies = movieModel.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error at function loadMovie from HomeViewController: \(error)")
            }
        }
    }
}

