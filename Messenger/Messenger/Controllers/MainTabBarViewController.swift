//
//  MainTabBarViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let nav1 = UINavigationController(rootViewController: ChatsViewController())
    let nav2 = UINavigationController(rootViewController: SettingsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let vc1 = ChatsViewController()
//        let vc2 = SettingsViewController()
//        let nav1 = UINavigationController(rootViewController: vc1)
//        let nav2 = UINavigationController(rootViewController: vc2)
        
        
        nav1.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message.fill"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 0)
        self.setViewControllers([nav1, nav2], animated: false)
        
        
//        vc1.closure = { unseenChat in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //[weak self] in
//                print("DEBUG: \(self)")
//                guard let strong = self else { print("DEBUG: nil"); return}
//                self?.nav1.tabBarItem.badgeValue = (unseenChat == 0 ? nil : String(unseenChat))
//                nav1.tabBarItem.badgeValue = (unseenChat == 0 ? nil : String(unseenChat))
//            }
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(unseenDidChange), name: .unseenChatDidChange, object: nil)
    }
    
    deinit {
        print("DEBUG: MainTabBarViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func unseenDidChange(_ notification: Notification) {
        if let unseenChat = notification.object as? Int {
            print("DEEBUG: notification inside")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.nav1.tabBarItem.badgeValue = (unseenChat == 0 ? nil : String(unseenChat))
            }
        }
    }
}
