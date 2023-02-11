//
//  ChatModel.swift
//  Messenger
//
//  Created by Đức Anh Trần on 03/02/2023.
//

import Foundation
import MessageKit
import FirebaseFirestore

/// The chat model to upload to database
struct ChatDatabase {
    var chatId: String
    var otherUser: User
    var latestMessage: LatestMessage
    
    var dictionary: [String: Any] {
        return [
            "chat_id": chatId,
            "other_user": otherUser.dictionary,
            "latest_message": latestMessage.dictionary
        ]
    }
}

extension ChatDatabase: ModelSerializable {
    init?(dictionary: [String: Any]) {
        guard let chatId = dictionary["chat_id"] as? String,
              let user = dictionary["other_user"] as? [String: Any],
              let otherUserId = user["user_id"] as? String,
              let otherUserName = user["full_name"] as? String,
              let otherUserProfileImageUrl = user["profile_image_url"] as? String,
              let message = dictionary["latest_message"] as? [String: Any],
              let senderId = message["sender_id"] as? String,
              let kind = message["kind"] as? String,
              let content = message["content"] as? String,
              let isRead = message["is_read"] as? Bool,
              let timeStamp = message["sent_date"] as? Timestamp else { return nil }
        
        let latestMessage = LatestMessage(senderId: senderId,
                                          kind: kind,
                                          content: content,
                                          sentDate: timeStamp.dateValue(),
                                          isRead: isRead)
        let otherUser = User(userId: otherUserId,
                             name: otherUserName,
                             profileImageUrl: otherUserProfileImageUrl)
        self.init(chatId: chatId,
                  otherUser: otherUser,
                  latestMessage: latestMessage)
    }
}

struct LatestMessage {
    var senderId: String
    var kind: String
    var content: String
    var sentDate: Date
    var isRead: Bool = false
    
    var dictionary: [String: Any] {
        return [
            "sender_id": senderId,
            "kind": kind,
            "content": content,
            "sent_date": Timestamp(date: sentDate),
            "is_read": isRead
        ]
    }
}

/// The message model to upload to database
struct MessageDatabase {
    var messageId: String
    var sender: User
    var receiver: User
    var content: String
    var kind: String
    var sentDate: Date
    
    var dictionary: [String: Any] {
        return [
            "message_id": messageId,
            "sender": sender.dictionary,
            "receiver": receiver.dictionary,
            "content": content,
            "kind": kind,
            "sent_date": Timestamp(date: sentDate)
        ]
    }
}
