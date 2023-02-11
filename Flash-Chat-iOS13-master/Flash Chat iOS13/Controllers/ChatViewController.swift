//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Messsage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.titleFlashChat
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.reusableCell)
        
        gatherMessage()
        loadMessage()
    }
    
    func gatherMessage() {
        
            db.collection(K.FStore.collectionName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let queryDocuments = querySnapshot?.documents {
                    for document in queryDocuments {
                        let messageData = document.data()
                        if let sender = messageData[K.FStore.senderField] as? String, let body = messageData[K.FStore.bodyField] as? String {
                            self.messages.append(Messsage(sender: sender, body: body))
                        }
                    }
                }
            }
        }
    }
    
    func loadMessage() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateFile)
            .addSnapshotListener { querySnapshot, error in
                // self.messages = []
                
                if let err = error {
                    print(err)
                } else {
//                    if let documents = querySnapshot?.documents {
//                        for document in documents {
//                            let dataMessage = document.data()
//                            if let sender = dataMessage[K.FStore.senderField] as? String, let body = dataMessage[K.FStore.bodyField] as? String {
//
//                                self.messages.append(Messsage(sender: sender, body: body))
//
//                                DispatchQueue.main.async {
//                                    self.tableView.reloadData()
//
//                                    let indexPath = IndexPath(row: documents.count - 1, section: 0)
//                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//                                }
//                            }
//                        }
//                    }
                    if let queryDocuments = querySnapshot?.documents {
                        if let lastDocuments = queryDocuments.last {
                            let messageData = lastDocuments.data()
                            if let sender = messageData[K.FStore.senderField] as? String, let body = messageData[K.FStore.bodyField] as? String {
                                self.messages.append(Messsage(sender: sender, body: body))
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    let indexPath = IndexPath(row: queryDocuments.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let message = messageTextfield.text, let userEmail = Auth.auth().currentUser?.email {
            if message != "" {
                messageTextfield.text = ""
                
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: userEmail,
                    K.FStore.bodyField: message,
                    K.FStore.dateFile: Date().timeIntervalSince1970
                ]) { error in
                    if let err = error {
                        print(err)
                    } else {
                        DispatchQueue.main.async {
                            self.loadMessage()
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textAlignment = .right
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textAlignment = .left
        }
        
        return cell
    }
}
