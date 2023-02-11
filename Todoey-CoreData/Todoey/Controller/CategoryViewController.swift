//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Đức Anh Trần on 20/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    // MARK: - Table view delagate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { field in
            field.placeholder = "Add a category"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - DataCore methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
        
        tableView.reloadData()
    }
}
