//
//  ChatManger.swift
//  Messenger
//
//  Created by Đức Anh Trần on 03/02/2023.
//

import Foundation
import FirebaseFirestore
import MessageKit

/// The class to handle database logic. Including: create new chat,
final class ChatManager {
    
    /// Return the shared default object.
    static let shared = ChatManager()
    
    private init() {}
    
    private let db = Firestore.firestore()
}

// MARK: - Public functions
extension ChatManager {
    
    /// Create a new chat between current user and other user.
    ///
    /// - Parameters:
    ///   - otherUser: The other user to start a new chat with.
    ///   - message: The inital message to send.
    ///   - completion: The block to execute after create new chat between two users.
    public func createNewChat(
        withUser otherUser: User,
        message: Message,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // Create current user.
        guard let currentUserId = UserDefaultsValue.id,
              let currentUserName = UserDefaultsValue.name,
              let currentUserProfileImageUrl = UserDefaultsValue.profileImageUrl else {
            print("DEBUG: current user info error")
            completion(.failure(ChatManagerError.currentUserIsNil))
            return
        }
        let currentUser = User(userId: currentUserId,
                               name: currentUserName,
                               profileImageUrl: currentUserProfileImageUrl)
        
        // Create latest message.
        var content = ""
        switch message.kind {
        case .text(let messageText):
            content = messageText
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .attributedText(_), .emoji(_), .audio(_), .contact(_), .linkPreview(_), .custom(_):
            break
        }
        
        let chatId = UUID().uuidString
        
        // Create chat document for current user.
        let currentUserLatestMessage = LatestMessage(senderId: currentUserId,
                                                     kind: message.kind.toString,
                                                     content: content,
                                                     sentDate: message.sentDate,
                                                     isRead: true)
        let currentUserChatData = ChatDatabase(chatId: chatId,
                                               otherUser: otherUser,
                                               latestMessage: currentUserLatestMessage)
        
        // Create chat document for other user.
        let otherUserLatestMessage = LatestMessage(senderId: currentUserId,
                                                   kind: message.kind.toString,
                                                   content: content,
                                                   sentDate: message.sentDate,
                                                   isRead: false)
        let otherUserChatData = ChatDatabase(chatId: chatId,
                                             otherUser: currentUser,
                                             latestMessage: otherUserLatestMessage)
        
        // Write data to database at current user document.
        db.collection("users").document(currentUserId)
            .collection("chats").document(chatId)
            .setData(currentUserChatData.dictionary) { [weak self] error in
                guard error == nil else {
                    print("DEBUG: Create chat document for current user error: \(error!)")
                    completion(.failure(error!))
                    return
                }
                
                // Write data to database at other user document.
                self?.db.collection("users").document(otherUser.userId)
                    .collection("chats").document(chatId)
                    .setData(otherUserChatData.dictionary) { error in
                        guard error == nil else {
                            print("DEBUG: Create chat document for other user error: \(error!)")
                            completion(.failure(error!))
                            return
                        }
                        
                        // Create root collection `Chats`, which hold the whole chat of all users.
                        let messageId = message.messageId
                        
                        let messageDocumentData = MessageDatabase(messageId: messageId,
                                                                  sender: currentUser,
                                                                  receiver: otherUser,
                                                                  content: content,
                                                                  kind: message.kind.toString,
                                                                  sentDate: message.sentDate)
                        self?.db.collection("chats").document(chatId)
                            .collection("messages").document(messageId)
                            .setData(messageDocumentData.dictionary) { error in
                                guard error == nil else {
                                    print("DEBUG: Create root collection `Chats` error: \(error!)")
                                    completion(.failure(error!))
                                    return
                                }
                                completion(.success(chatId))
                            }
                    }
            }
    }
    
    /// Fetch all chats for current user.
    ///
    /// - Parameters:
    ///   - userId: The id of user that being fetched all chat.
    ///   - completion: The block to execute after
    public func fetchAllChats(
        forUser userId: String,
        completion: @escaping (Result<[ChatDatabase], Error>) -> Void
    ) {
        db.collection("users").document(userId)
            .collection("chats").addSnapshotListener { querySnapshot, error in
                guard let queryDocuments = querySnapshot?.documents else {
                    completion(.failure(error!))
                    return
                }
                guard !queryDocuments.isEmpty else {
                    completion(.failure(ChatManagerError.dataIsEmpty))
                    return
                }
                let documents = queryDocuments.map { $0.data() }
                
                let chatsData: [ChatDatabase] = documents.compactMap {
                    guard let chat = ChatDatabase(dictionary: $0) else { return nil }
                    return chat
                }
                
                completion(.success(chatsData))
            }
    }
    
    /// Fetch all messages within a chat from chat id.
    ///
    ///  - Parameters:
    ///    - chatId: The id of the chat that hold all messages.
    public func fetchAllMessages(
        from chatId: String,
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {
        db.collection("chats").document(chatId)
            .collection("messages").order(by: "sent_date")
            .addSnapshotListener { querySnapshot, error in
                guard let queryDocuments = querySnapshot?.documents else {
                    completion(.failure(error!))
                    return
                }
                
                guard !queryDocuments.isEmpty else {
                    completion(.failure(ChatManagerError.dataIsEmpty))
                    return
                }
                let documents = queryDocuments.map { $0.data() }
                
                let messagesData: [Message] = documents.compactMap {
                    guard let message = Message(dictionary: $0) else { return nil }
                    return message
                }
                
                completion(.success(messagesData))
            }
        
    }
    
    /// Send message to append to a specify chat with given chat id.
    ///
    /// - Parameters:
    ///   - chatId: The id of the chat that hold all messages.
    ///   - message: The message for sent.
    ///   - otherUser: the other user belong to this chat.
    public func sendMessage(
        to chatId: String,
        message: Message,
        otherUser: User,
        completion: @escaping (Bool) -> Void
    ) {
        // Create current user.
        guard let currentUserId = UserDefaultsValue.id,
              let currentUserName = UserDefaultsValue.name,
              let currentUserProfileImageUrl = UserDefaultsValue.profileImageUrl else {
            print("DEBUG: current user info error")
            completion(false)
            return
        }
        let currentUser = User(userId: currentUserId,
                               name: currentUserName,
                               profileImageUrl: currentUserProfileImageUrl)
        
        // Create message document data.
        var content = ""
        switch message.kind {
        case .text(let messageText):
            content = messageText
            break
        case .photo(let media):
            if let urlString = media.url?.absoluteString {
                content = urlString
            }
            break
        case .video(_):
            break
        case .location(_):
            break
        case .attributedText(_), .emoji(_), .audio(_), .contact(_), .linkPreview(_), .custom(_):
            break
        }
        
        let messageId = message.messageId
        let messageDocumentData = MessageDatabase(messageId: messageId,
                                                  sender: currentUser,
                                                  receiver: otherUser,
                                                  content: content,
                                                  kind: message.kind.toString,
                                                  sentDate: message.sentDate)
        
        // Add new message document to `messages` sub-collection
        db.collection("chats").document(chatId)
            .collection("messages").document(messageId)
            .setData(messageDocumentData.dictionary) { [weak self] error in
                guard error == nil else {
                    print("DEBUG: sendMessage error: \(error!)")
                    completion(false)
                    return
                }
                let currentUserLatestMessage = LatestMessage(senderId: currentUserId,
                                                             kind: message.kind.toString,
                                                             content: content,
                                                             sentDate: message.sentDate,
                                                             isRead: true)
                let otherUserLatestMessage = LatestMessage(senderId: currentUserId,
                                                           kind: message.kind.toString,
                                                           content: content,
                                                           sentDate: message.sentDate,
                                                           isRead: false)
                self?.updateLatestMessage(forUsers: [currentUserId, otherUser.userId],
                                          in: chatId,
                                          withMessages: [currentUserLatestMessage, otherUserLatestMessage],
                                          completion: completion)
            }
    }
    
    // MARK: - Xoá hội thoại trên databse, khó quá nghiên cứu sau
    
    //    public func deleteChatOfUser(
    //        userId: String,
    //        with chatId: String,
    //        completion: @escaping (Error?) -> Void
    //    ) {
    //        db.collection("users").document(userId)
    //            .collection("chats").document(chatId)
    //            .delete { error in
    //                guard error == nil else {
    //                    completion(error!)
    //                    return
    //                }
    //                completion(nil)
    //            }
    //    }
    //
    //    public func deleteChatRoom(
    //        chatId: String,
    //        otherUserId: String,
    //        completion: @escaping (Bool) -> Void
    //    ) {
    //        let batch = db.batch()
    //
    //        db.collection("users").document(otherUserId)
    //            .collection("chats").document(chatId)
    //            .getDocument { [weak self] querySnapshot, _ in
    //                if let isExists = querySnapshot?.exists, isExists {
    //                    print("DATABASE: document exist")
    //                    completion(false)
    //                } else {
    //                    self?.db.collection("chats").document(chatId)
    //                        .collection("messages").getDocuments { querySnapshot, error in
    //                            guard let queryDocuments = querySnapshot?.documents, error == nil else {
    //                                print("DATABASE: message documnent == nil")
    //                                completion(false)
    //                                return
    //                            }
    //                            for queryDocument in queryDocuments {
    //                                batch.deleteDocument(queryDocument.reference)
    //                            }
    //                            batch.commit { error in
    //                                guard error == nil else {
    //                                    print("DATABASE: batch commit failed")
    //                                    completion(false)
    //                                    return
    //                                }
    //
    //                                self?.db.collection("chats").document(chatId).delete { error in
    //                                    guard error == nil else {
    //                                        completion(false)
    //                                        print("DATABASE: cannot delete chat_id document")
    //                                        return
    //                                    }
    //                                    print("DATABSE: can delete all")
    //                                    completion(true)
    //                                }
    //                            }
    //                        }
    //                }
    //            }
    //
    //
    //    }
    //
    //    public func isChatStillExist(
    //        otherUserId: String,
    //        completion: @escaping (String?) -> Void
    //    ) {
    //        guard let currentUserId = UserDefaultsValue.id else { return }
    //
    //        db.collection("users").document(otherUserId)
    //            .collection("chats").getDocuments { querySnapshot, error in
    //                guard let queryDocuments = querySnapshot?.documents, error == nil else {
    //                    completion(nil)
    //                    return
    //                }
    //                let documents = queryDocuments.map { $0.data() }
    //
    //                var hasFound: Bool = false
    //                var chatId: String = ""
    //                for document in documents {
    //                    if let targetUser = document["other_user"] as? [String: Any],
    //                       let targetUserId = targetUser["user_id"] as? String,
    //                       let targetChatId = document["chat_id"] as? String
    //                    {
    //                        if targetUserId == currentUserId {
    //                            hasFound = true
    //                            chatId = targetChatId
    //                            break
    //                        }
    //                    }
    //                }
    //                hasFound ? completion(chatId) : completion(nil)
    //            }
    //    }
    
    /// Update the status of current user whether they've seen message or not.
    ///
    /// - Parameters:
    ///   - userId: the id of user for being update.
    ///   - chatId: The id of the chat that hold all messages.
    public func userDidSeenMessage(
        currentUserId userId: String,
        chatId: String,
        completion: @escaping (Error?) -> Void
    ) {
        db.collection("users").document(userId)
            .collection("chats").document(chatId)
            .updateData([
                "latest_message.is_read": true
            ]) { error in
                guard error == nil else {
                    completion(error!)
                    return
                }
                completion(nil)
            }
    }
    
}

// MARK: - Private function
extension ChatManager {
    
    /// Update `"latest_message"` field in a given chat.
    private func updateLatestMessage(
        forUsers userIds: [String],
        in chatId: String,
        withMessages latestMessages: [LatestMessage],
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserId = UserDefaultsValue.id else { return }
        var latestMessage: LatestMessage!
        
        for userId in userIds {
            if userId == currentUserId {
                latestMessage = latestMessages[0]
            } else {
                latestMessage = latestMessages[1]
            }
            
            db.collection("users").document(userId)
                .collection("chats").document(chatId)
                .updateData([
                    "latest_message": latestMessage.dictionary
                ]) { error in
                    guard error == nil else {
                        print("DEBUG: updateLatestMessage error: \(error!)")
                        completion(false)
                        return
                    }
                }
        }
        
        completion(true)
    }
}

enum ChatManagerError: Error {
    case failedToFetchData
    case dataIsEmpty
    case currentUserIsNil
    
    var localizedDescription: String {
        switch self {
        case .failedToFetchData:
            return "Failed to fetch data from Database"
        case .dataIsEmpty:
            return "Data is empty"
        case .currentUserIsNil:
            return "Current user is nil"
        }
    }
}
