//
//  NewChatViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 01/02/2023.
//

import UIKit

protocol NewChatViewControllerDelegate: AnyObject {
    func viewController(_ viewController: NewChatViewController, didTapOnRowAt user: User)
}

class NewChatViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUserLabel: UILabel!
    
    private var searchController: UISearchController!
    weak var delegate: NewChatViewControllerDelegate?
    
    private var users: [User] = []
    private var results: [User] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: NewChatViewController: did load")
        configureView()
        fetchAllUser()
    }
    
    deinit {
        print("DEBUG: NewChatViewController: deinit")
    }
    
    private func configureView() {
        title = "New message"

        // navigation item
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancelButton)
        )
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewChatTableViewCell.nib(), forCellReuseIdentifier: NewChatTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        // search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // no user label
        noUserLabel.isHidden = true
        noUserLabel.text = "No user"
        noUserLabel.textColor = .systemBlue
        noUserLabel.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    // MARK: - Selector
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Helper
    private func fetchAllUser() {
        print("DEBUG: NewChatViewController: fetchAllUser() invoke")
        AuthManager.shared.fetchAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.results = users
                
                print("DEBUG: NewChatViewController: fetchAllUser() successfully")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("DEBUG: NewChatViewController: fetchAllUser() error: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewChatTableViewCell.identifier, for: indexPath) as? NewChatTableViewCell else {
            return UITableViewCell()
        }
        let user = results[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = results[indexPath.row]
        searchController.isActive = false
        dismiss(animated: true) {
            self.delegate?.viewController(self, didTapOnRowAt: user)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - UISearchResultsUpdating
extension NewChatViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        // Edge Case: reload tableView when search bar become empty
        if (searchBar.text?.count == 0) && (results.count != users.count) {
            results = users
            tableView.reloadData()
            return
        }
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("DEBUG: Search bar empty")
            return
        }
        
        results = users.filter { $0.name.contains(query) }
        tableView.reloadData()
    }
}
