//
//  UIViewExtension.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import Foundation
import UIKit

extension UIView {
    func roundCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func configBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
