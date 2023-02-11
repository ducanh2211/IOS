//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Items"
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let currentCategory = self.selectedCategory {
                if textField.text?.count == 0 { return }
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }

        alert.addAction(action)
        alert.addTextField { field in
            field.placeholder = "Add a item"
            textField = field
        }

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Realm Model Manipulation methods

    func loadItems(with item: Results<Item>? = nil) {
        if let item = item {
            todoItems = item
        } else {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        }

        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoItemForDeletion = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(todoItemForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchBar.text?.count == 0 { return }
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//        tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        } else {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            let sortedTodoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            loadItems(with: sortedTodoItems)
        }
    }
    
}

