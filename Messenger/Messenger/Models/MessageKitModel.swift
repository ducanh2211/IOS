//
//  MessageKitModel.swift
//  Messenger
//
//  Created by Đức Anh Trần on 04/02/2023.
//

import Foundation
import MessageKit
import FirebaseFirestore

protocol ModelSerializable {
    init?(dictionary: [String: Any])
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

extension Message: ModelSerializable {
    init?(dictionary: [String : Any]) {
        guard let messageId = dictionary["message_id"] as? String,
              let _sender = dictionary["sender"] as? [String: Any],
              let senderId = _sender["user_id"] as? String,
              let senderName = _sender["full_name"] as? String,
              let _receiver = dictionary["receiver"] as? [String: Any],
              let _ = _receiver["user_id"] as? String,
              let _ = _receiver["full_name"] as? String,
              let content = dictionary["content"] as? String,
              let kindString = dictionary["kind"] as? String,
              let timeStamp = dictionary["sent_date"] as? Timestamp
        else {
            return nil
        }
        
        var kind: MessageKind!
        if kindString == "text" {
            kind = .text(content)
        } else if kindString == "photo" {
            guard let url = URL(string: content),
                  let placeholder = UIImage(systemName: "questionmark.circle") else { return nil }
            let media = Media(url: url,
                              image: nil,
                              placeholderImage: placeholder,
                              size: CGSize(width: 200, height: 200))
            kind = .photo(media)
        }
        
        
        let sender = Sender(senderId: senderId, displayName: senderName)
        
        self.init(sender: sender,
                  messageId: messageId,
                  sentDate: timeStamp.dateValue(),
                  kind: kind)
    }
}

extension MessageKind {
    var toString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attribute_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
    
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
