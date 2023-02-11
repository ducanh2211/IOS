//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Đức Anh Trần on 14/12/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

struct K {
    static let titleFlashChat = "⚡️FlashChat"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let reusableCell = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct FStore {
        static let collectionName = "Messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateFile = "date"
    }
    
    struct BrandColors {
            static let purple = "BrandPurple"
            static let lightPurple = "BrandLightPurple"
            static let blue = "BrandBlue"
            static let lighBlue = "BrandLightBlue"
        }
}
