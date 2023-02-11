//
//  Extension.swift
//  Messenger
//
//  Created by Đức Anh Trần on 31/01/2023.
//

import Foundation
import UIKit
import MessageKit

extension UITextField {
    func setPaddingPoints(left: CGFloat?, right: CGFloat?) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left ?? 0, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right ?? 0, height: self.frame.size.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}

extension UIImageView {
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}

extension Date {
    func convertToString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Notification.Name {
    static let unseenChatDidChange = Notification.Name(rawValue: "unseenChatDidChange")
}
