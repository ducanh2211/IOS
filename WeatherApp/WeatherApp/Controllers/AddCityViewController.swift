//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import UIKit

class AddCityViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UITextField!
    @IBOutlet weak var addCityButton: UIButton!
    var addCityVM = AddCityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.6, alpha: 0.9)

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let city = cityNameLabel.text {
            addCityVM.create(city: city)
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
