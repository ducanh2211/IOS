//
//  OrderTableViewController.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var orderVM = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadOrders()
    }

    func setupUI() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.5, alpha: 0.95)
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadOrders() {
        WebService().load(resource: Order.all) { result in
            switch result {
            case .success(let orders):
                self.orderVM.orders = orders.map { order in
                    return OrderViewModel(order: order)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderVM.numberOfRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        let order = orderVM.orderAtRow(at: indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = order.type
        content.secondaryText = order.size
        cell.contentConfiguration = content
        return cell
    }
}

