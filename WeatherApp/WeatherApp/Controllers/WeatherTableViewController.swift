//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import UIKit

class WeatherTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    func setupUI() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.6, alpha: 0.9)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
    }
}
