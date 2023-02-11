//
//  AddNewOrderViewController.swift
//  CoffeeApp
//
//  Created by Đức Anh Trần on 29/12/2022.
//

import UIKit

class AddNewOrderViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addTableView: UITableView!
    var addOrderVM = AddNewOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView.delegate = self
        addTableView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.5, alpha: 0.95)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let indexPath = addTableView.indexPathForSelectedRow else { return }
        let selectedType = addOrderVM.type[indexPath.row]
        
        let segmentIndex = segmentedControl.selectedSegmentIndex
        let selectedSize = segmentedControl.titleForSegment(at: segmentIndex)
        
        let name = nameTextField.text
        let email = emailTextField.text
        
        addOrderVM.name = name
        addOrderVM.email = email
        addOrderVM.selectedType = selectedType
        addOrderVM.selectedSize = selectedSize
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - table view data source
extension AddNewOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOrderVM.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addTableView.dequeueReusableCell(withIdentifier: "AddNewOrderTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = addOrderVM.type[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = addTableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = addTableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .none
    }
}

