//
//  HomeViewController.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    var viewModel = MovieListViewModel()
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupTableView()
    }

    func configView() {
        let headerView = HeroTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeTableView.tableHeaderView = headerView
        homeTableView.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Setup
    func setupTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
            homeTableView.register(CollectionViewTableViewCell.nib(), forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        homeTableView.register(HeroTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HeroTableHeaderView.identifier)
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        print("number of section: \(self.viewModel.numberOfSections)")
        return self.viewModel.numberOfSections
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of row in section: \(self.viewModel.numberOfRowsInSection)")
            return self.viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.getTitleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell", for: indexPath)
                as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        self.viewModel.getData(at: indexPath) { result in
            print("get data function")
            switch result {
            case .success(let cellVM):
                print("get data success")
                cell.configure(movies: cellVM)
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
