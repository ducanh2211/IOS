//
//  SettingsViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 02/02/2023.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    
    private var settings = [SettingsViewModel]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: SettingsViewController: did load")
        initialSetup()
        populateTableView()
    }
    
    deinit {
        print("DEBUG: SettingsViewController: deinit")
    }
    
    private func initialSetup() {
        let headerView = createTableHeaderView()
        tableView.tableHeaderView = headerView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }
    
    // MARK: - Helper
    private func createTableHeaderView() -> UIView? {
        guard let currentUserName = UserDefaultsValue.name,
              let currentUserProfileImageUrl = UserDefaultsValue.profileImageUrl else { return nil }
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.bounds.width,
                                              height: 120))
        let imageView = UIImageView(frame: CGRect(x: (headerView.bounds.width - 80) / 2,
                                                  y: 0,
                                                  width: 80,
                                                  height: 80))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.sd_setImage(with: URL(string: currentUserProfileImageUrl))
        
        let label = UILabel(frame: CGRect(x: (headerView.bounds.width - 80) / 2,
                                          y: imageView.bounds.height,
                                          width: 200,
                                          height: 50))
        label.text = currentUserName
        headerView.addSubview(imageView)
        headerView.addSubview(label)
        
        return headerView
    }
    
    private func populateTableView() {
        settings.append(SettingsViewModel(title: "Saved Messages", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Recent Calls", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Notifications and Sounds", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Privacy and Security", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Data and Storage", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Appearence", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Languages", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Stickers and Emoji", image: nil, handler: nil))
        settings.append(SettingsViewModel(title: "Log out", image: nil, handler: { [weak self] in
            let actionSheet = UIAlertController(title: "Log Out", message: "Do you want to log out?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
                self?.didtapLogout()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(actionSheet, animated: true)
        }))
    }
    
    private func didtapLogout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(nil, forKey: "uid")
            UserDefaults.standard.set(nil, forKey: "name")
            UserDefaults.standard.set(nibName, forKey: "profile_image_url")
            
            let vc = UINavigationController(rootViewController: LoginViewController())
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(
                vc,
                options: .transitionFlipFromLeft,
                animated: true)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        let setting = settings[indexPath.row]
        cell.configure(with: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = settings[indexPath.row]
        setting.handler?()
    }
}

// MARK: - SettingsTableViewCell class
class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: SettingsViewModel) {
        var content = self.defaultContentConfiguration()
        content.text = model.title
        self.contentConfiguration = content
        
    }
}
