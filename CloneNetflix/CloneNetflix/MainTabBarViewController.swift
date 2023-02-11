//
//  MainTabBarViewController.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    func setupTabBar() {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let upcomingVC = UpcomingViewController()
        let upcomingNav = UINavigationController(rootViewController: upcomingVC)
        upcomingVC.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "play.circle"), tag: 1)
        
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        let downloadsVC = DownloadsViewController()
        let downloadsNav = UINavigationController(rootViewController: downloadsVC)
        downloadsVC.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 3)
        
        tabBar.tintColor = .label
        
        self.setViewControllers([homeNav, upcomingNav, searchNav, downloadsNav], animated: true)
    }
    
}
