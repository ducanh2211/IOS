//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        items[indexPath.row].done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        return cell
    }

    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveItems()
    }
    
    // MARK: - Data source methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving items: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error loading items: \(error)")
        }
        
        tableView.reloadData()
    }

    
    // MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if textField.text?.count == 0 { return }
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.items.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(action)
        alert.addTextField { field in
            field.placeholder = "Add a item"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchBar.text?.count == 0 { return }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        } else {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        }
    }
    
}
