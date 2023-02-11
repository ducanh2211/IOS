//
//  UserGeneral.swift
//  Messenger
//
//  Created by Đức Anh Trần on 02/02/2023.
//

import Foundation

/// Store all important informations of current user
struct UserDefaultsValue {
    static var id: String? {
        guard let id = UserDefaults.standard.string(forKey: "uid") else {
            return nil
        }
        return id
    }
    
    static var name: String? {
        guard let name = UserDefaults.standard.string(forKey: "name") else {
            return nil
        }
        return name
    }
    
    static var profileImageUrl: String? {
        guard let profileImageUrl = UserDefaults.standard.string(forKey: "profile_image_url") else {
            return nil
        }
        return profileImageUrl
    }
}

/// The actual user of the app
struct User {
    var userId: String
    var name: String
    var email: String? = nil
    var password: String? = nil
    var profileImageUrl: String
    
    var dictionary: [String: Any] {
        if let email = email, let password = password {
            return [
                "user_id": userId,
                "full_name": name,
                "email_address": email,
                "password": password,
                "profile_image_url": profileImageUrl
            ]
        }
        else {
            return [
                "user_id": userId,
                "full_name": name,
                "profile_image_url": profileImageUrl
            ]
        }
    }
}

extension User: ModelSerializable {
    init?(dictionary: [String: Any]) {
        guard let userId = dictionary["user_id"] as? String,
              let name = dictionary["full_name"] as? String,
              let profileImageUrl = dictionary["profile_image_url"] as? String else {
            return nil
        }

        self.init(userId: userId,
                  name: name,
                  profileImageUrl: profileImageUrl)
        
    }
}

