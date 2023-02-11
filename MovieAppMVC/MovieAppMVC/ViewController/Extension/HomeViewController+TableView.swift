//
//  HomeViewController+TableView.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Setup
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCell()
    }
    
    func registerCell() {
        self.tableView.register(HomeTableViewCell.uiNibCell, forCellReuseIdentifier: HomeTableViewCell.idetifier)
    }
    
    // MARK: - Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell với custom HomeTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.idetifier, for: indexPath) as! HomeTableViewCell
        
        // tạo biến movie
        let movie = self.movies[indexPath.row]
        
        // gọi tới function populateTableView() và truyền vào movie
        cell.populateTableView(movie: movie)
        
        return cell
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tạo DetailsVC bằng storyboard
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.storyBoardId) as! DetailsViewController
        
        // gán movie = với movie tại SelectRow
        let movie = self.movies[indexPath.row]
        
        // gán biến movie tại DetailsVC bằng movie được chọn
        detailsViewController.movie = movie
        
        // push DetailsVC vào navigation controller
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
