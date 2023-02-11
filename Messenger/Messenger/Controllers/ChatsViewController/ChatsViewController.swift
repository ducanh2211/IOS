//
//  ChatsViewController.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

protocol ChatsViewControllerDelegate: AnyObject {
    func viewController(_ viewController: ChatsViewController, numberOfUnseenChatDidChange unseenChat: Int)
}

class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noChatLabel: UILabel!
//    var closure: ((Int) -> Void)?
    
    private var chatList: [ChatDatabase] = []
    var numberOfUnseenChat: Int = 0 {
        willSet {
            NotificationCenter.default.post(name: .unseenChatDidChange, object: newValue)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        print("UserDefaults path: \(path)")
        print("DEBUG: ChatsViewController: did load")
        initalSetup()
        listeningForChats()
//        navigationController?.tabBarItem.badgeValue = "10"
    }
    
    deinit {
        print("DEBUG: ChatsViewController: deinit")
    }
    
    private func initalSetup() {
        title = "Chats"
        
        // no chat label
        noChatLabel.isHidden = true
        
        // navigation item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(rightBarButtonItemDidTap))
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatsTableViewCell.nib(), forCellReuseIdentifier: ChatsTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    // MARK: - Selector
    
    @objc private func rightBarButtonItemDidTap() {
        let vc = NewChatViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.delegate = self
        present(nav, animated: true)
    }
    
    // MARK: - Helper
    
    private func listeningForChats() {
        guard let userId = UserDefaultsValue.id else { return }
        print("DEBUG: ChatsViewController: listeningForChats() invoke")
        
        ChatManager.shared.fetchAllChats(forUser: userId) { [weak self] result in
            switch result {
            case .success(let chatsData):
                print("DEBUG: ChatsViewController: fetchAllChats() successfully")
                self?.chatList = chatsData
                self?.noChatLabel.isHidden = true
                
                // Pass data back to MainTabBarViewController
                let numberOfUnseenChat = chatsData.filter({ $0.latestMessage.isRead == false }).count
                self?.numberOfUnseenChat = numberOfUnseenChat
//                self?.closure?(numberOfUnseenChat)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("DEBUG: ChatsViewController: fetchAllChats() error: \(error.localizedDescription)")
                self?.noChatLabel.isHidden = false
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.identifier,
                                                       for: indexPath) as? ChatsTableViewCell else {
            return UITableViewCell()
        }
        let chat = chatList[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let currentUserId = UserDefaultsValue.id else { return }
        
        let chat = chatList[indexPath.row]
        let user = User(userId: chat.otherUser.userId,
                        name: chat.otherUser.name,
                        profileImageUrl: chat.otherUser.profileImageUrl)
        
        let vc = ChatDetailsViewController(otherUser: user,
                                           chatId: chat.chatId)
        navigationController?.pushViewController(vc, animated: true)
        
        if chat.latestMessage.isRead == false {
            ChatManager.shared.userDidSeenMessage(currentUserId: currentUserId, chatId: chat.chatId) { error in
                if let error = error {
                    print("DEBUG: ChatsViewController: userDidSeenMessage() error: \(error)")
                } else {
                    print("DEBUG: ChatsViewController: userDidSeenMessage() success")
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.chatList.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .left)
            
            // Khó quá nghiên cứu sau, xoá hội thoại
            //            ChatManager.shared.deleteChatOfUser(userId: currentUserId, with: chatId) { error in
            //                if let error = error {
            //                    print(error.localizedDescription)
            //                } else {
            //                    ChatManager.shared.deleteChatRoom(chatId: chatId, otherUserId: otherUserId) { delete in
            //                        if delete {
            //                            print("DEBUG: deleteChatRoom() successfully")
            //                        } else {
            //                            print("DEBUG: deleteChatRoom() failed / needn't delete")
            //                        }
            //                    }
            //                }
            //            }
            
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let read = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            completion(true)
        }
        read.image = UIImage(systemName: "envelope.badge.fill")
        read.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [read])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

// MARK: - NewChatVC Delegate

extension ChatsViewController: NewChatViewControllerDelegate {
    
    func viewController(_ viewController: NewChatViewController, didTapOnRowAt user: User) {
        guard let currentUserId = UserDefaultsValue.id else { return }
        
        
        
        if let targetChat = chatList.first(where: { $0.otherUser.userId == user.userId }) {
            // Open exist chat with given chat id
            print("DEBUG: dong dau")
            let vc = ChatDetailsViewController(otherUser: user, chatId: targetChat.chatId)
            navigationController?.pushViewController(vc, animated: true)
            
            if targetChat.latestMessage.isRead == false {
                ChatManager.shared.userDidSeenMessage(currentUserId: currentUserId, chatId: targetChat.chatId) { [weak self] error in
                    if let error = error {
                        print("DEBUG: ChatsViewController: userDidSeenMessage() error: \(error)")
                    } else {
                        print("DEBUG: ChatsViewController: userDidSeenMessage() success")
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
        else {
            // Khó quá nghiên cứu sau, xoá hội thoại
            //            ChatManager.shared.isChatStillExist(otherUserId: user.userId) { chatId in
            //                if let chatId = chatId {
            //                    // Chat room exist -> Open chat room with given chat id
            //                    print("DEBUG: dong hai")
            //                    let vc = ChatDetailsViewController(otherUser: user, chatId: chatId)
            //                    self.navigationController?.pushViewController(vc, animated: true)
            //                } else {
            //                    // Chat room doesn't exist -> Create a new chat room
            //                    print("DEBUG: Dong ba")
            //                    let vc = ChatDetailsViewController(otherUser: user, chatId: nil, isNewChat: true)
            //                    self.navigationController?.pushViewController(vc, animated: true)
            //                }
            //            }
            
            let vc = ChatDetailsViewController(otherUser: user, chatId: nil, isNewChat: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

