//
//  SettingsModel.swift
//  Messenger
//
//  Created by Đức Anh Trần on 09/02/2023.
//

import Foundation

struct SettingsViewModel {
    var title: String
    var image: String?
    var handler: (() -> Void)?
}
